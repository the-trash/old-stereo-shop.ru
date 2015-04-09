describe CsvUtf do
  let(:file_path) { 'spec/assets/non_utf.csv' }
  let(:data) { File.read(file_path) }
  let(:detection) { CharlockHolmes::EncodingDetector.new.detect data }

  describe '.open' do
    context 'without passing block' do
      subject { CsvUtf.open file_path }

      it { is_expected.to be_a CSV }
      it { is_expected.not_to be_closed }

      it do
        data = double('data')
        csv = double('csv')
        expect(CsvUtf).to receive(:read_file_in_utf8).and_return(data)
        expect(CSV).to receive(:new).with(data, {}).and_return(csv)
        expect(subject).to eq(csv)
      end

      after { subject.close if subject.is_a?(CSV) }
    end

    context 'when block is passed' do
      subject { CsvUtf.open(file_path) { |csv| @passed_csv = csv } }
      before { subject }

      it 'passes csv to that block' do
        expect(@passed_csv).to be_a CSV
      end

      it 'closes csv after block execution' do
        expect(@passed_csv).to be_closed
      end
    end
  end

  describe '.encoding_detector' do
    subject { CsvUtf.encoding_detector }
    it { is_expected.to be_a CharlockHolmes::EncodingDetector }
  end

  describe '.convert_data_to_utf8' do
    subject { CsvUtf.convert_data_to_utf8 data, detection }

    context 'when detector detecs encoding' do
      it do
        expect(CharlockHolmes::Converter).to receive :convert
        subject
      end

      it { is_expected.to eq("id,foobar\n44,foo–bar\n") }
    end
  end

  describe '.read_file_in_utf8' do
    subject { CsvUtf.read_file_in_utf8 file_path }

    it do
      expect(CsvUtf).to receive(:convert_data_to_utf8).with(data, detection)
      subject
    end
  end

  describe '.encoding_recognized?' do
    let!(:detection) { nil }

    context 'when detection fails to encoding_recognized?' do
      subject { CsvUtf.encoding_recognized? detection }

      it do
        is_expected.not_to receive(:convert_data_to_utf8).with(data, detection)
      end
    end
  end

  describe 'when long file received' do
    let!(:long_file_path) { 'spec/assets/long_non_utf.csv' }
    let!(:long_data) { File.read(long_file_path) }
    let!(:detection) { CharlockHolmes::EncodingDetector.new.detect long_data }

    it do
      expect(CsvUtf.convert_data_to_utf8 long_data, detection).to eq("id,foobar\n44,foobar\n" * 50)
    end
  end
end
