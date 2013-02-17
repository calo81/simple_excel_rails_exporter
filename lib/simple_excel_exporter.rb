require 'date'
require 'axlsx'

module Exportable
  module ClassMethods
    def export(*properties)
      @exportable_properties = properties
    end

    def exportables
      @exportable_properties
    end
  end

  def to_xls
    [self].to_xls
  end

  def self.included(base)
    base.extend(ClassMethods)
  end
end

class Array
  def to_xls
    p = Axlsx::Package.new
    p.workbook.add_worksheet(:name => "Excel export") do |sheet|
      if self[0].is_a?(Exportable)
        sheet.add_row self[0].class.exportables.map(&:to_s)
      end
      each do |element|
        if element.is_a?(Exportable)
          values = element.class.exportables.map do |property|
            element.send(property.to_sym)
          end
          sheet.add_row values
        end
      end


    end
    p.use_shared_strings = true
    p.to_stream
  end
end