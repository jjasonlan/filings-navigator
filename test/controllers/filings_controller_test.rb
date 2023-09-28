require "rails_helper"
require "test_helper"

class FilingsControllerTest < ActionDispatch::IntegrationTest
  test 'parse_from_xml parses XML correctly' do
    # Create a Nokogiri::XML::Document object from a test XML string
    doc = Nokogiri::XML('<root><child>Test</child></root>')

    # Stub the XML_XPATH constant
    FilingsController::XML_XPATH = {child: {path: 'child'}}

    # Call the method
    data = @controller.send(:parse_from_xml, doc)

    # Check the result
    assert_equal({child: 'Test'}, data)
  end
end
