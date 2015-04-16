describe Import::BaseImport do
  subject { described_class.new }

  describe '#errors_message' do
    let(:errors_message) { I18n.t \
      'brand',
      scope: Product::ImportEntry::ERRORS_SCOPE,
      title: ''
    }

    specify {
      expect(subject.errors_message('brand', title: '')).to eq(errors_message)
    }
  end
end
