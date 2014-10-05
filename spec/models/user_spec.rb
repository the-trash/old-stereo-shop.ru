RSpec.describe User, type: :model do
  context 'relations' do
    it do
      should have_many(:votes).
        dependent(:destroy).
        class_name('Rating').
        with_foreign_key(:user_id).
        inverse_of(:user)
    end

    it { should have_many(:reviews).dependent(:destroy) }
  end

  context 'validates' do
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_confirmation_of :password }
  end
end
