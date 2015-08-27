shared_examples 'a Seoble resource' do
  let(:controller_name) { controller.controller_name }
  let(:assignable) { send(controller_name.singularize) }

  subject { response }

  it "responds with seo title" do
    expect(assigns(:meta_tags)['title']).to eq assignable.seo_title
  end

  it "responds with seo description" do
    expect(assigns(:meta_tags)['description']).to eq assignable.seo_description
  end

  it "responds with keywords" do
    expect(assigns(:meta_tags)['keywords']).to eq assignable.keywords
  end
end
