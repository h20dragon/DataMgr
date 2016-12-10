require 'spec_helper'

describe DataMgr do
  it 'has a version number' do
    expect(DataMgr::VERSION).not_to be nil
  end

  it 'load data object' do

    dsl = DataMgr::DSL.instance.loadData('./spec/fixtures/dut.json')
    q=dsl.getDataElement('getData(firstname)')
    expect(dsl.is_a?(DataMgr::DataModel)).to be true
  end


  it 'load DB yaml' do

    isLoaded = DataMgr::DSL.instance.loadDB('./spec/fixtures/connect.yml')
    expect(isLoaded).to be true
  end


end
