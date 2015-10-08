LayoutMakeOrderInOneClick = require './views/make_order_in_one_click/layout'
RatableWithReviewLayout = require './views/ratable_with_reviews/ratable_with_reviews'
NewReview = require './views/new_review/layout'
AdditionalOptionsLayout = require './views/additional_options/layout'

Order = require './models/order'
Review = require './models/review'
Product = require './models/product'

Application = new Marionette.Application

Application.addRegions
  orderInOneClickRegion: '.l-make-order-in-one-click'
  ratableWithReviews: '.l-product-ratable-with-reviews'
  newReview: '.l-new-review'
  additionalOptions: '.l-additional-options'
  defaultTitle: '.b-product-default-title'
  customizedTitle: '.b-product-customized-title'
  defaultGallery: '.b-product-default-gallery'
  customizedGallery: '.b-product-customized-gallery'
  defaultDescription: '.b-product-default-description'
  customizedDescription: '.b-product-customized-description'
  defaultPriceWithDiscount: '.b-product-default-price-with-discount'
  customizedPriceWithDiscount: '.b-product-customized-price-with-discount'

Application.addInitializer ->
  @orderInOneClickRegion.show new LayoutMakeOrderInOneClick model: new Order()
  # TODO make ratable in share component
  @ratableWithReviews.show new RatableWithReviewLayout()
  @newReview.show new NewReview model: new Review()
  if gon.product.has_additional_options
    @additionalOptions.show new AdditionalOptionsLayout
      model: new Product(gon.product)
      regions:
        defaultTitle: @defaultTitle
        customizedTitle: @customizedTitle
        defaultGallery: @defaultGallery
        customizedGallery: @customizedGallery
        defaultDescription: @defaultDescription
        customizedDescription: @customizedDescription
        defaultPriceWithDiscount: @defaultPriceWithDiscount
        customizedPriceWithDiscount: @customizedPriceWithDiscount

module.exports = Application
