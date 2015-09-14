class BaseForm < Struct.new(:model, :form_attributes)
  include ActiveModel::Validations

  def initialize model, attributes
    super model, attributes.with_indifferent_access
    extract_attributes! form_attributes
  end

  def persisted?
    false
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  private

    def persist!
      model.save!
    end

    def extract_attributes! attributes
      attributes.each_pair { |key, value| send "#{key}=", value }
    end
end
