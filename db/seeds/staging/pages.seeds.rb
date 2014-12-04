after 'staging:post_categories' do
  admin       = AdminUser.first
  slugs_pages = %w(about payment contacts delivery help return)

  slugs_pages.each do |slug|
    Page.create(
      admin_user: admin,
      slug: slug,
      title: I18n.t("views.pages.#{ slug }"),
      full_text: 'Необходимо наполнить своим текстом'
    )
  end
end
