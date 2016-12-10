require 'spec_helper'

describe DataMgr do
  it 'has a version number' do
    expect(DataMgr::VERSION).not_to be nil
  end

  it 'create object DataMgr::Model' do

    obj = DataMgr::DataModel.new('./spec/fixtures/dut.json')
    rc=obj.getDataElement('getData(firstname)')
    puts "=> RC : #{rc}"

    rc2=obj.getDataElement('getData(address).get(city)')
    puts "=> city : #{rc2}"

    expect(obj.is_a?(DataMgr::DataModel) && rc=='Peter' && rc2=='New York City').to be true
   # expect(false).to eq(true)
  end



end
