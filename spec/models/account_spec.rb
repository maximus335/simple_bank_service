require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'class methods' do
    context '#new' do
      subject { build(:account) }
      it { is_expected.to be_instance_of Account }
    end
  end

  describe 'instance_methods' do
    context '#save' do
      subject { build(:account).save }
      it { is_expected.to be_truthy }
      it { expect { subject }.to change(Account, :count).by(1) }
    end

    context '#update' do
      before { create(:account) }
      let(:hash_for_update) { attributes_for(:account) }
      subject { Account.last.update(hash_for_update) }
      it { is_expected.to be_truthy }
    end

    context '#destroy' do
      before { create(:account) }
      subject { Account.last.destroy }
      it { is_expected.to be_truthy }
    end
  end

  describe 'validations_presence' do
    it 'should require a number' do
      expect(build(:account, number: '')).not_to be_valid
    end

    it 'should require a blocked' do
      expect{ create(:account, blocked: '') }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it 'should require a balance' do
      expect { create(:account, balance: '') }.to raise_error(ActiveRecord::NotNullViolation)
    end
  end

  describe 'validations nil' do
    it 'should require a number' do
      expect(build(:account, number: nil)).not_to be_valid
    end

    it 'should require a blocked' do
      expect { create(:account, blocked: nil) }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it 'should require a balance' do
      expect { create(:account, balance: nil) }.to raise_error(ActiveRecord::NotNullViolation)
    end
  end

  describe 'validations_uniqueness' do
    context 'when number is not uniq' do
      let(:number) { '1' * 20 }
      before { create(:account, number: number) }

      it 'raises unique validation error number' do
        expect(build(:account, number: number)).not_to be_valid
      end
    end
  end

  describe 'validation_fomat number' do
    it 'wrong format number' do
      expect(build(:account, number: 'wrong-format')).not_to be_valid
    end
  end
end
