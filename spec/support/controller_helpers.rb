shared_context 'a successful request' do
  it 'should returns an OK (200) status code' do
    expect(response.status).to eq(200)
  end
end

shared_context 'a successful render index template' do
  it 'should render index template' do
    expect(response).to render_template('index')
  end
end

shared_context 'a successful render show template' do
  it 'should render show template' do
    expect(response).to render_template('show')
  end
end

shared_context 'a successful render template' do |template_name|
  it 'should render template' do
    expect(response).to render_template(template_name)
  end
end

shared_context 'response should be equal' do |example|
  it 'should be equal example' do
    expect(response.body).to eq(example)
  end
end
