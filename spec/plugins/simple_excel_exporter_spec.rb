require "spec_helper"
require 'roo'
require 'ostruct'
require 'simple_excel_exporter'

describe 'excel exporter' do
  describe "Initialization" do

    it "should add the renderer" do
      ActionController::Renderers::RENDERERS.has_key?(:xls).should == true
    end

    it "should register mime type" do
      Mime[:xls].to_s.should == "application/vnd.ms-excel"
    end

    it "should create to_xls method" do
      [].should respond_to :to_xls
    end
  end

  describe "render" do
     class TestExcel < OpenStruct
       include Exportable

       export :name, :type_p

     end

     let(:array_of_exportables)  {
        [TestExcel.new(:id => 5, :name => 'A', :type_p => 'T1'), TestExcel.new(:id => 6, :name => 'B', :type_p => 'T2')]
     }

     it "should render excel on array to_xls" do
        excel = array_of_exportables.to_xls
        File.open('/tmp/example_streamed.xlsx', 'w') { |f| f.write(excel.read) }
        book = Roo::Excelx.new('/tmp/example_streamed.xlsx')
        book.to_s.should == '{[1, 2]=>"type_p", [2, 1]=>"A", [1, 1]=>"name", [3, 2]=>"T2", [3, 1]=>"B", [2, 2]=>"T1"}'
     end
  end
end