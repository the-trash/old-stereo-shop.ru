class Import::Meta < Import::BaseImport
  delegate :meta, to: :import_entry

  def params
    parse_meta.presence || default_meta_hash
  end

  private

  def parse_meta(first_seporator = ';', second_seporator = ':', third_separator = '|')
    {}.tap do |a|
      meta.split(first_seporator).each do |data|
        splited_data = data.split(second_seporator)

        parse_meta_key(a, splited_data, third_separator) if splited_data[1].presence
      end
    end if meta.present?
  end

  def parse_meta_key(hash, data, separator)
    hash[data[0]] = data[1].gsub(separator, ', ')
  end

  def default_meta_hash
    {
      keywords: nil,
      seo_title: nil,
      seo_description: nil
    }
  end
end
