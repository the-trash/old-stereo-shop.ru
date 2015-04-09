class CsvUtf < CSV
  class << self
    def open file_path, options = {}
      csv = new read_file_in_utf8(file_path), options

      if block_given?
        begin
          yield csv
        ensure
          csv.close
        end
      else
        csv
      end
    end

    def read_file_in_utf8 file_path
      data = File.read(file_path)
      detection = encoding_detector.detect data
      convert_data_to_utf8 data, detection if encoding_recognized? detection
    end

    def convert_data_to_utf8 data, detection
      CharlockHolmes::Converter.convert data, detection[:encoding], 'UTF-8'
    end

    def encoding_detector
      @encoding_detector ||= CharlockHolmes::EncodingDetector.new
    end

    def encoding_recognized? detection
      detection and detection[:encoding]
    end
  end
end
