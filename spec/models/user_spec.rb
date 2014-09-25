RSpec.describe User, type: :model do
  context 'validates' do
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_confirmation_of :password }
  end
end
