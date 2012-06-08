class AttributeBuilder
  def initialize(attributes, selected_attributes)
    @attributes = attributes
    @selected_attributes = selected_attributes
  end

  def attributes
    @attributes.select do |attribute, value|
      @selected_attributes.include? attribute
    end
  end
end
