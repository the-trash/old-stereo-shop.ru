describe Newletter do
  describe '#save' do
    context 'when posts_count greater than zero' do
      let(:newletter) { build :newletter }

      it 'should not be receive #set_posts_count' do
        expect(newletter).not_to receive(:set_posts_count)
        newletter.save
      end
    end

    context 'when posts_count equal zero' do
      let(:newletter) { build :newletter, :posts_count_zero }

      it 'should be receive #set_posts_count' do
        expect(newletter).to receive(:set_posts_count)
        newletter.save
      end
    end
  end
end
