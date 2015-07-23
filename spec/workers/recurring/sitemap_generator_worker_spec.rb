describe Recurring::SitemapGeneratorWorker do
  subject { File.exists?('public/uploads/sitemap.xml.gz') }

  before { described_class.new.perform }

  specify { expect(subject).to be_truthy }
end
