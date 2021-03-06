module ReviewHelper
  def review_author(review)
    content_tag(:p, class: 'author_name') do
      raw(
        review.user_name +
        content_tag(:span, I18n.l(review.created_at, format: :short))
      )
    end
  end

  %w(pluses cons body).each do |m|
    define_method(:"review_#{ m }") do |review|
      content_tag(:p, class: m) do
        raw(
          I18n.t("views.reviews.#{ m }") +
          content_tag(:span, review.send(:"#{ m }"))
        )
      end if review.send(:"#{ m }?")
    end
  end
end
