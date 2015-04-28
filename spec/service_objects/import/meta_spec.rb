describe Import::Meta do
  let(:meta_struct) { described_class.new import_entry }
  let(:default_meta_hash) {
    {
      keywords: nil,
      seo_title: nil,
      seo_description: nil
    }
  }

  subject { meta_struct.params }

  context 'when meta params exists' do
    let(:import_entry) { create :product_import_entry }
    let(:expected_meta) {
      {
        expected_keywords: 'bla bla, bla b, asd',
        expected_seo_description: 'bla la',
        expected_seo_title: 'asfsdf'
      }
    }

    %w(keywords seo_title seo_description).each do |key|
      specify { expect(subject[key]).to eq(expected_meta[:"expected_#{key}"]) }
    end
  end

  context 'when meta params is empty' do
    let(:import_entry) { create :product_import_entry, meta: '' }

    specify { expect(subject).to eq(default_meta_hash) }
  end

  context 'when meta params is nil' do
    let(:import_entry) { create :product_import_entry, meta: nil }

    specify { expect(subject).to eq(default_meta_hash) }
  end
end
