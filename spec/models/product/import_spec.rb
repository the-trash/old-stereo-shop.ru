describe Product::Import, type: :model do
  let(:product_import) { build :product_import }

  describe '#save' do
    subject { product_import.save }

    specify {
      expect { subject }.to change(product_import.import_entries, :size).from(0).to(1)
    }

    specify {
      expect { subject }.to change(ProductImportWorker.jobs, :size).by(1)
    }
  end
end
