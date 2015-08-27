describe SeoSetting, type: :model do
  context 'validates' do
    it { should validate_presence_of :action_name }
    it { should validate_presence_of :controller_name }
  end

  describe 'creation' do
    subject { seo_setting.save! }

    context "with url attribute" do
      let(:seo_setting) { build :seo_setting, :empty, :with_url } 

      it "creates with controller_name" do
        expect { subject }.to change { seo_setting.controller_name }.to 'brands'
      end

      it "creates with action_name" do
        expect { subject }.to change { seo_setting.action_name }.to 'index'
      end
    end

    context "without url" do
      let(:seo_setting) { build :seo_setting, :without_url }

      specify do
        expect { subject }.to change(SeoSetting, :count).by(1)
      end

      context "with missing params" do
        let(:seo_setting) { build :seo_setting, :empty, :without_url }
        
        it "doesn't create" do
          expect { subject }.to raise_error ActiveRecord::RecordInvalid
        end
      end
    end
  end
end
