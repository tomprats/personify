class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :birthday

  def attributes(requested_attrs = nil)
    result = super(requested_attrs)
    extra_attributes.each { |attr| result[attr.to_sym] = object.send(attr) }
    result
  end

  def birthday
    object.birthday.strftime("%m/%d/%Y")
  end

  private
  def extra_attributes
    (instance_options[:extra_attributes] || "").split(",").compact
  end
end
