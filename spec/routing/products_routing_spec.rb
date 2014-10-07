describe 'routes for Products' do
  it 'GET /products' do
    expect(get: '/products').to route_to(controller: 'products', action: 'index')
  end

  it 'GET /products/:id' do
    expect(get: '/products/1').
      to route_to(controller: 'products', action: 'show', id: '1')
  end

  it 'POST /products/:id/add_review' do
    expect(post: '/products/1/add_review').
      to route_to(controller: 'products', action: 'add_review', id: '1')
  end
end
