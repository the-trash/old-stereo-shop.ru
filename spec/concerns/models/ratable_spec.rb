shared_examples_for 'ratable' do
  let(:model) { described_class }
  let(:instance_var) { FactoryGirl.create(model.to_s.underscore.to_sym) }
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
