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



  it 'add config to DataMgr::DB' do

    DataMgr::DB.instance.debug=true

    rc = DataMgr::DB.instance.load('./spec/fixtures/connect.yml')

    hit=DataMgr::DB.instance.getConfig('KUNAL')
    puts "HIT => #{hit}"
    isConnected=DataMgr::DB.instance.connect('KUNAL')

    puts "| isConnected : #{isConnected}"

    q="use p0170036ou8o_000 select JR_KEY, JD_KEY, STATUS_CODE FROM CT_JOB_RUN WHERE START_TIME > '2013-09-17' AND END_TIME < '2013-10-17'"

    DataMgr::DB.instance.run(id: 'KUNAL', query: q)
    DataMgr::DB.instance.run(id: 'KUNAL', query: q, report: 'ReportOne')

    isDisconnected=DataMgr::DB.instance.close('KUNAL')

    result=DataMgr::DB.instance.getResult(id: 'KUNAL', report: 'ReportOne')
    puts "RESULT => #{result.class} => #{result}"

    expect(rc && isConnected && isDisconnected).to be true
  end



end
