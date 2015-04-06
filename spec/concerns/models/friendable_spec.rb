shared_examples_for 'friendable' do
  let(:model) { described_class }
  let(:instance_var) { FactoryGirl.create(model.to_s.underscore.to_sym) }

  it '#slug_candidates' do
    expect(instance_var.slug_candidates).to eq([:title, [:id, :title]])
  end
end
