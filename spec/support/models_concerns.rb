shared_context 'needed variables' do
  let(:model) { described_class }
  let(:instance_var) { FactoryGirl.create(model.to_s.underscore.to_sym) }
end

shared_examples_for 'ratable' do
  include_context('needed variables')
  let(:rating) { FactoryGirl.create(:rating, votable: instance_var) }

  it 'has many ratings' do
    should have_many(:ratings).
      dependent(:destroy)
  end

  # context 'after_add recalculate_average_score' do
  #   it 'should receive' do
  #     expect(instance_var).to receive(:recalculate_average_score)
  #     recalculate_average_score.ratings << rating
  #   end
  # end

  context '#can_vote?' do
    let(:user) { FactoryGirl.create(:user) }
    let(:user_rating) { FactoryGirl.create(:rating, votable: instance_var, user: user) }

    it 'should return true' do
      rating

      expect(instance_var.can_vote?(user.id)).to eq(true)
    end

    it 'should return false' do
      user_rating

      expect(instance_var.can_vote?(user.id)).to eq(false)
    end
  end
end

shared_examples_for 'friendable' do
  include_context('needed variables')

  it '#slug_candidates' do
    expect(instance_var.slug_candidates).to eq([:title, [:id, :title]])
  end
end

shared_examples_for 'statable' do
  include_context('needed variables')

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

shared_examples_for 'photoable' do
  it 'have many photos' do
    should have_many(:photos).
      dependent(:destroy)
  end

  it { should accept_nested_attributes_for(:photos).allow_destroy(true) }
end
