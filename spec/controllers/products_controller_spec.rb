require 'spec_helper'
require 'roo'
require 'ostruct'
require 'simple_excel_exporter'


class TestModel < OpenStruct
  include Exportable

  export :name, :type_p
end


class TestController < ApplicationController
  def index
    respond_to do |format|
      format.xls { render :xls => [TestModel.new(:name => 'product1', :id => 1, :type_p => 'gran product'),
                                   TestModel.new(:name => 'product2', :id => 2, :type_p => 'no gran product')] }
    end
  end
end

ExcelExporter::Application.routes.draw do
  resources :test
end

describe TestController do

  before(:each) do
    Zip::DOSTime.instance_eval do
      def now ; Zip::DOSTime.new() ; end
    end
    Time.stub(:now).and_return(Time.at(0))
  end

  it "should generate Excel file" do
    get :index, :format => 'xls'
    response.content_type.should == "application/vnd.ms-excel"
    response.header['Content-Disposition'].should == "attachment; filename=Array_Thu-Jan-01-01:00:00-1970.xls"
    File.open('/tmp/example_streamed.xlsx', 'w') { |f| f.write(response.body) }
    book = Roo::Excelx.new('/tmp/example_streamed.xlsx')
    book.to_s.should == '{[1, 2]=>"type_p", [2, 1]=>"product1", [1, 1]=>"name", [3, 2]=>"no gran product", [3, 1]=>"product2", [2, 2]=>"gran product"}'
  end
end