require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'class methods' do
    context '#new' do
      subject { build(:transaction) }
      it { is_expected.to be_instance_of Transaction }
    end
  end

  describe 'instance_methods' do
    context '#save' do
      subject { build(:transaction).save }
      it { is_expected.to be_truthy }
      it { expect { subject }.to change(Transaction, :count).by(1) }
    end

    context '#update' do
      before { create(:transaction) }
      let(:hash_for_update) { attributes_for(:transaction) }
      subject { Transaction.last.update(hash_for_update) }
      it { is_expected.to be_truthy }
    end

    context '#destroy' do
      before { create(:transaction) }
      subject { Transaction.last.destroy }
      it { is_expected.to be_truthy }
    end
  end

  describe 'validations presence' do
    it 'should require a amount' do
      expect { create(:transaction, amount: '') }.to raise_error(ActiveRecord::NotNullViolation)
    end
  end

  describe 'validations nil' do
    it 'should require a amount' do
      expect { create(:transaction, amount: nil) }.to raise_error(ActiveRecord::NotNullViolation)
    end
  end

  describe 'validation_fomat from' do
    it 'wrong format from' do
      expect(build(:transaction, from: 'wrong-format')).not_to be_valid
    end
  end

  describe 'validation_fomat to' do
    it 'wrong format to' do
      expect(build(:transaction, to: 'wrong-format')).not_to be_valid
    end
  end

  describe 'validation_type enum' do
    it 'wrong type' do
      expect(build(:transaction, type_operation: 'wrong type')).not_to be_valid
    end
  end
end
