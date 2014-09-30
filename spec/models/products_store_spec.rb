describe ProductsStore do
  context 'relations' do
    %i(store product).each do |m|
      it { should belong_to(m) }
    end
  end

  context 'validates' do
    %i(count product store).each do |f|
      it { should validate_presence_of(f) }
    end
  end

  it { should delegate(:title).to(:store).with_prefix }
end
