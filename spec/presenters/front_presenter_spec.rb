describe FrontPresenter do
  let(:user) { nil }

  subject { described_class.new user }

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
    let!(:product_category2) { create :product_category, :moderated }
    let!(:product) { create :product, product_category: product_category1 }

    specify { expect(subject.product_categories).to include(product_category1) }
    specify { expect(subject.product_categories).not_to include(product_category2) }
  end

  describe '#show_news?' do
    let!(:post_category) { create :post_category, :news }

    subject { described_class.new.show_news? }

    specify { expect(subject).to be_falsey }

    context 'when posts exist for news post category' do
      let!(:post) { create :post, post_category: post_category }

      specify { expect(subject).to be_truthy }
    end
  end

  describe '#show_useful_information?' do
    let!(:post_category) { create :post_category, :useful_information }

    subject { described_class.new.show_useful_information? }

    specify { expect(subject).to be_falsey }

    context 'when posts exist for useful information post category' do
      let!(:post) { create :post, post_category: post_category }

      specify { expect(subject).to be_truthy }
    end
  end
end
