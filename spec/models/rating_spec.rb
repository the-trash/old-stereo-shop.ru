describe Rating do
  context 'relations' do
    it { should belong_to(:votable) }
    it { should belong_to(:user).class_name('User').inverse_of(:votes) }
    it { should have_one(:review) }
  end

  context 'validates' do
    %i(votable user_id score).each do |f|
      it { should validate_presence_of(f) }
    end
  end

  context 'scopes' do
    context 'for_removing' do
      let(:ratings_larger) { create_list(:rating, 3, score: rand(3..5)) }
      let(:rating_less) { create_list(:rating, 3, score: rand(1..2)) }

      it 'return not empty collection' do
        ratings_larger

        expect(Rating.for_removing(2)).to eq(ratings_larger)
      end

      it 'return empty collection' do
        rating_less

        expect(Rating.for_removing(3)).to eq([])
      end
    end
  end
end
