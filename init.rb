require 'axlsx'
require 'simple_excel_exporter'

ActionController::Renderers.add :xls do |obj, options|
  filename = options[:filename] || obj.class.name + "_" +Time.now.strftime("%a-%b-%d-%H:%M:%S-%Y")
  raise "Object #{obj} doesn't respond to to_xls" unless obj.respond_to?(:to_xls)
  str = obj.to_xls.read
  send_data str, :type => Mime::XLS, :disposition => "attachment; filename=#{filename}.xls"
end

Mime::Type.register "application/vnd.ms-excel", :xls