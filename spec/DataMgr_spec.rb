require 'spec_helper'

describe DataMgr do
  it 'has a version number' do
    expect(DataMgr::VERSION).not_to be nil
  end

  it 'create object DataMgr::Model' do

    obj = DataMgr::DataModel.new('./spec/fixtures/dut.json')
    expect(obj.is_a?(DataMgr::DataModel))
   # expect(false).to eq(true)
  end
end
