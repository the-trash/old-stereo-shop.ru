shared_examples_for 'statable' do
  let(:model) { described_class }
  let(:instance_var) { FactoryGirl.create(model.to_s.underscore.to_sym) }

  states = %i(draft published removed moderated)

  states.each do |s|
    let(s) { FactoryGirl.create(model.to_s.underscore.to_sym, s) }
  end

  it 'STATES contains the data set' do
    expect(model::STATES).to eq(states)
  end

  it { expect(model.draft).to include(draft) }
  it { expect(model.published).to include(published) }
  it { expect(model.removed).to include(removed) }
  it { expect(model.moderated).to include(moderated) }
end
