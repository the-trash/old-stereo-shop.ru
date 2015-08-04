describe OrdersController do
  let!(:order) { create :order }

  # TODO add test for update and complete

  context 'GET /orders/:id/delivery' do
    before { get :delivery, id: order.id, step: 'delivery', next_step: 'authentification' }

    it_behaves_like 'a successful request'
    it_behaves_like 'a successful render template', 'delivery'
  end

  context 'GET /orders/:id/authentification' do
    before { get :authentification, id: order.id, step: 'authentification', next_step: 'payment' }

    it_behaves_like 'a successful request'
    it_behaves_like 'a successful render template', 'authentification'
  end

  context 'GET /orders/:id/payment' do
    before { get :payment, id: order.id, step: 'payment', next_step: 'complete' }

    it_behaves_like 'a successful request'
    it_behaves_like 'a successful render template', 'payment'
  end

  context 'GET /orders/:id/success_complete' do
    before { get :success_complete, id: order.id, step: 'success_complete' }

    it_behaves_like 'a successful request'
    it_behaves_like 'a successful render template', 'success_complete'
  end

  context 'GET /orders/:id/complete' do
    before { get :complete, id: order.id, step: 'success_complete' }

    it_behaves_like 'a successful request'
    it_behaves_like 'a successful render template', 'orders/success_complete'
  end
end
