describe Recurring::SitemapGeneratorWorker do
  subject { File.exists?('public/sitemap.xml.gz') }

  before { described_class.new.perform }

  specify { expect(subject).to be_truthy }
end
