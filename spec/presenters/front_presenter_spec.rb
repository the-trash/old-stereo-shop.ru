describe FrontPresenter do
  let(:user) { nil }

  subject { described_class.new user }

  describe '#meta' do
    let(:default_meta) {
      {
        seo_title: I18n.t('seo_title', scope: [:meta, :default]),
        keywords: I18n.t('keywords', scope: [:meta, :default]),
        seo_description: I18n.t('seo_description', scope: [:meta, :default])
      }
    }

    specify { expect(subject.meta).to eq(default_meta) }
  end

  describe '#news_category' do
    let!(:news_category) { create :post_category, title: I18n.t('news') }

    specify { expect(subject.news_category).to eq(news_category) }
  end

  describe '#useful_information_category' do
    let!(:useful_information_category) { create :post_category, title: I18n.t('useful_information') }

    specify { expect(subject.useful_information_category).to eq(useful_information_category) }
  end

  describe '#user_wishlist' do
    specify { expect(subject.user_wishlist).to eq([]) }

    context 'when user exists' do
      let(:user) { create :user }
      let(:product) { create :product }
      let!(:wish) { create :wish, user: user, product: product }

      specify { expect(subject.user_wishlist[product.id]).to include(wish) }
    end
  end

  describe '#product_categories' do
    let!(:product_category1) { create :product_category }
    let!(:product_category2) { create :product_category }
    let!(:product) { create :product, product_category: product_category1 }

    specify { expect(subject.product_categories).to include(product_category1) }
    specify { expect(subject.product_categories).not_to include(product_category2) }
  end
end
