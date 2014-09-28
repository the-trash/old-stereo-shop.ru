after 'development:posts' do
  products = Product.all
  users = User.all

  progressbar =
    ProgressBar.create({
      title: 'Create ratings for products',
      total: products.size,
      format: '%t %B %p%% %e'
    })

  ratings =
    [].tap do |a|
      products.find_each do |product|
        a <<
          [].tap do |b|
            rand(5..15).times do |n|
              b << FactoryGirl.build(:rating, {
                votable: product,
                user: users.sample
              })
            end

            b.uniq! { |rat| rat.user_id }
          end

        progressbar.increment
      end
    end

  Rating.import(ratings.flatten)

  progressbar_recalculate_ratings =
    ProgressBar.create({
      title: 'Recalculate average ratings for products',
      total: products.size,
      format: '%t %B %p%% %e'
    })

  products.find_each do |product|
    product.send(:recalculate_average_score)
  end
end
