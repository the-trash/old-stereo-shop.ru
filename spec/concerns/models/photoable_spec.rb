shared_examples 'photoable' do
  it 'have many photos' do
    should have_many(:photos).dependent(:destroy)
  end

  it { should accept_nested_attributes_for(:photos).allow_destroy(true) }
end
