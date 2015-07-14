class CsvFileUploader < FileUploader
  def filename
    @name ||= "#{SecureRandom.hex(10)}.#{file.extension}" if original_filename.present?
  end

  def extension_white_list
    ['csv']
  end
end
