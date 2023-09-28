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
    award_list: {
      multiple: true,
      path: "Return/ReturnData/IRS990ScheduleI/RecipientTable",
      amended_return_indicator: "AmendedReturnInd",
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
      validate_and_store(data)

      # transaction to write
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
          # if subnode.nil?
          #   puts "bad thing at #{subpath[:path]}"
          # end
          subdata[subkey] = parse_subpaths(subnode, subpath)
        elsif subpath.instance_of?(String)
          match = node.at_xpath(subpath)&.text
          if match.present?
            subdata[subkey] = match
          end
        # else
        #   puts "missing #{subkey} #{subpath}"
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
    puts data[:award_list]
    puts data[:filer]
    puts data[:filing]
  end
  
end
