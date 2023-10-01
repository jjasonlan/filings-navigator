require 'pp'
require 'nokogiri'
require 'open-uri'

class FilingsController < ApplicationController
  XML_XPATH = {
    filing: {
      path: "Return/ReturnHeader",
      return_timestamp: "ReturnTs",
      tax_period_end_date: ["TaxPeriodEndDt", "TaxPeriodEndDate"]
    },
    filer: {
      path: "Return/ReturnHeader/Filer",
      ein: "EIN",
      name: ["Name", "BusinessName/BusinessNameLine1", "BusinessName/BusinessNameLine1Txt"],
      address: {
        path: ["USAddress", "AddressUS"],
        line1: ["AddressLine1", "AddressLine1Txt"],
        city: ["City", "CityNm"],
        state: ["State", "StateAbbreviationCd"],
        zip: ["ZIPCode", "ZIPCd"]
      }
    },
    filing_data: {
      path: "Return/ReturnData/IRS990",
      amended_return_indicator: "AmendedReturnInd",
    },
    award_list: {
      multiple: true,
      path: "Return/ReturnData/IRS990ScheduleI/RecipientTable",
      ein: ["EINOfRecipient", "RecipientEIN"],
      recipient_name: ["RecipientNameBusiness", "RecipientBusinessName/BusinessNameLine1", "RecipientBusinessName/BusinessNameLine1Txt"],
      recipient_address: {
        path: ["USAddress", "AddressUS"],
        line1: ["AddressLine1", "AddressLine1Txt"],
        city: ["City", "CityNm"],
        state: ["State", "StateAbbreviationCd"],
        zip: ["ZIPCode", "ZIPCd"]
      },
      award_amount: ["AmountOfCashGrant", "CashGrantAmt"]
    }
  }

  def index
  end

  def create
    url = params[:url]
    if params[:data]
      # not implemented
      raise NoMethodError 
    elsif url
      doc = begin
        Nokogiri::XML(URI.open(url)) do |config|
          config.noblanks.strict
        end
      rescue
        render json: { error: 'Error parsing XML from URL.' }, status: :unprocessable_entity
        return
      end
      doc.remove_namespaces!
      # Store the extracted data
      data = parse_from_xml(doc)
      # transaction to write
      validate_and_store(data)
      return
    else
      render json: { error: 'Please provide filing data or a URL.' }, status: :unprocessable_entity
      return
    end
  end

  private
  def parse_from_xml(doc)
    def parse_subpaths(node, config)
      subdata = {}
      path = config[:path]
      config.each do |subkey, subpath|
        next if [:path, :multiple].include?(subkey)
        if node.nil?
          puts "no data at #{path}/#{subpath}"
          next
        end
        if subpath.is_a?(Array)
          subpath.each do |p|
            match = node.at_xpath(p)&.text
            if match.present?
              subdata[subkey] = match
            end
          end
        elsif subpath.is_a?(Hash)
          subnode = if subpath[:path].is_a?(Array)
            subpath[:path].map { |p| node.at_xpath(p) }.compact.first
          else
            node.at_xpath(subpath[:path])
          end
          subdata[subkey] = parse_subpaths(subnode, subpath)
        elsif subpath.instance_of?(String)
          match = node.at_xpath(subpath)&.text
          if match.present?
            subdata[subkey] = match
          end
        else
          puts "missing #{subkey} #{subpath}"
          next
        end
      end
      subdata
    end
    data = {}
    XML_XPATH.each do |key, config|
      # assumes only top level has multiple nodes
      if config[:multiple]
        data[key] = []
        # assumes only a singular path for nodes with multiple matches
        doc.xpath(config[:path]).each do |node|
          award = parse_subpaths(node, config)
          data[key] << award
        end
      else
        data[key] = parse_subpaths(doc.xpath(config[:path]), config)
      end
    end
    data
  end

  def validate_and_store(data)
    data[:filer] => {ein:, name:, address:}
    filer_params = {
      ein: ein,
      name: name,
      address_line_1: address[:line1],
      city: address[:city],
      state: address[:state],
      zip: address[:zip]
    }
    @filer = Filer.new(filer_params)
    @filing = Filing.new(data[:filing].merge({
      amended: data[:filing_data][:amended_return_indicator] === "X"
    }))

    recipients = []
    award_lists = []
    data[:award_list].each do |award|
      recipient_params = {
        ein: award[:ein],
        name: award[:recipient_name],
        address_line_1: award[:recipient_address][:line1],
        city: award[:recipient_address][:city],
        state: award[:recipient_address][:state],
        zip: award[:recipient_address][:zip]
      }
      
      award_list_params = {
        amount: award[:award_amount]
      }
      # if missing any required params, ignore this entry
      if recipient_params.values.all? && award_list_params.values.all?
        recipient = Recipient.new(recipient_params)
        award_list = AwardList.new(award_list_params)
        recipients << recipient
        award_lists << award_list
      end
    end

    ActiveRecord::Base.transaction do

      @filer = Filer.create_with(filer_params).find_or_create_by!(ein: filer_params[:ein])
      @filing.filer_id = @filer.id
      @filing.save!
  
      recipients.each(&:save!)
      award_lists.each_with_index do |award_list, index|
        award_list.filing_id = @filing.id
        award_list.recipient_id = recipients[award_lists.index(award_list)].id
        award_list.save!
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
  
end
