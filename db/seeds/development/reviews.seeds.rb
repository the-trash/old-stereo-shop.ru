after 'development:ratings' do
  ratings  = Rating.all
  products = Product.includes(:reviews)
  users    = User.includes(:reviews)

  progressbar =
    ProgressBar.create({
      title: 'Create reviews for products',
      total: ratings.size,
      format: '%t %B %p%% %e'
    })

  progressbar_product =
    ProgressBar.create({
      title: 'Update cache counters for products',
      total: products.size,
      format: '%t %B %p%% %e'
    })

  progressbar_user =
    ProgressBar.create({
      title: 'Update cache counters for users',
      total: users.size,
      format: '%t %B %p%% %e'
    })

  reviews =
    [].tap do |a|
      ratings.find_each do |rating|
        a << FactoryGirl.build(:review, {
            user_id: rating.user_id,
            recallable_id: rating.votable_id,
            recallable_type: rating.votable_type,
            rating: rating
          })

        progressbar.increment
      end
    end

  Review.import(reviews)

  Product.reset_column_information
  products.each do |product|
    product.update_column(:reviews_count, product.reviews.size)
    progressbar_product.increment
  end

  # User.reset_column_information
  # users.each do |user|
  #   user.update_column(:reviews_count, user.reviews.size)
  #   progressbar_user.increment
  # end
end
