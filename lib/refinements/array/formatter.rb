module Refinements::Array::Formatter
  refine Array do
    def map_with_state_locale
      map { |k| [I18n.t(k, scope: [:activerecord, :attributes, :states, :state]), k] }
    end
  end
end
