after 'development:products' do
  CHAR_CATEGORY_COUNT = 10
  UNITS = %w(кг г мм Гц Ом)
  admins = AdminUser.all

  progressbar =
    ProgressBar.create({
      title: 'Create characteristic categories',
      total: CHAR_CATEGORY_COUNT,
      format: '%t %B %p%% %e'
    })

  characteristic_categories =
    [].tap do |a|
      CHAR_CATEGORY_COUNT.times do |n|
        a << FactoryGirl.build(:characteristic_category, {
          admin_user: admins.sample,
          position: n
        })
        progressbar.increment
      end
    end

  CharacteristicCategory.import(characteristic_categories)

  char_cats = CharacteristicCategory.all

  progressbar_char =
    ProgressBar.create({
      title: 'Create characteristics',
      total: CHAR_CATEGORY_COUNT,
      format: '%t %B %p%% %e'
    })

  characteristics =
    [].tap do |a|
      char_cats.each do |cat|
        rand(3..10).times do |n|
          a << FactoryGirl.build(:characteristic, {
            characteristic_category: cat,
            position: n,
            unit: UNITS.sample
          })
        end

        progressbar_char.increment
      end
    end

  Characteristic.import(characteristics)

  products  = Product.all
  char_cats = char_cats.includes(:characteristics)

  progressbar_char_product =
    ProgressBar.create({
      title: 'Generate characteristics for products',
      total: products.size,
      format: '%t %B %p%% %e'
    })

  char_products =
    [].tap do |a|
      products.find_each do |product|
        a <<
          [].tap do |b|
            rand(3..5).times do |n|
              char = char_cats.sample.characteristics.sample

              b << CharacteristicsProduct.new({
                product: product,
                characteristic: char,
                value: rand(10.1..500.9)
              })
            end

            b.uniq! { |c_p| c_p.characteristic_id }
          end

        progressbar_char_product.increment
      end
    end

  CharacteristicsProduct.import(char_products.flatten)
end
