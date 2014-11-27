after 'development:reviews' do
  users    = User.all
  products = Product.all

  progressbar =
    ProgressBar.create({
      title: 'Create carts for users',
      total: users.size,
      format: '%t %B %p%% %e'
    })

  users.find_each do |user|
    cart = FactoryGirl.create(:cart, user: user)

    carts_products =
      [].tap do |a|
        products.sample(3).each do |product|
          a << FactoryGirl.create(:carts_product, product: product, cart: cart)
        end
      end

    progressbar.increment
  end
end
