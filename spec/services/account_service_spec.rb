require 'rails_helper'

RSpec.describe AccountService do
  describe 'class methods' do
    subject { described_class }

    class_method = %w[
      new
      transfer
      credit
      debit
      balance
      balance_by_date
      turnover
    ]

    it { is_expected.to respond_to(*class_method) }

    context '#new' do
      subject { described_class.new }
      it { is_expected.to be_an_instance_of AccountService }
    end

    describe '#balance' do
      let!(:account) { create(:account) }
      let(:number) { account.number }
      subject { described_class.balance(number) }

      it 'should balance to equal `0.0`' do
        expect(subject).to eq(0.0)
      end

      context 'when account not found' do
        let(:number) { 'number' }

        it 'should raise AccountService::Errors::NotFound' do
          expect { subject }.to raise_error(AccountService::Errors::NotFound)
        end
      end
    end

    describe '#balance_by_date' do
      let!(:account) { create(:account) }
      let(:number) { account.number }
      let(:date) { Time.now.strftime('%Y-%m-%d') }
      subject { described_class.balance_by_date(number, date) }

      it 'should balance to equal `0.0`' do
        expect(subject).to eq(0.0)
      end

      context 'when account not found' do
        let(:number) { 'number' }

        it 'should raise AccountService::Errors::NotFound' do
          expect { subject }.to raise_error(AccountService::Errors::NotFound)
        end
      end

      context 'when account is blocked' do
        let!(:account) { create(:account, blocked: true) }

        it 'should raise AccountService::Errors::Blocked' do
          expect { subject }.to raise_error(AccountService::Errors::Blocked)
        end
      end
    end

    describe '#debit' do
      let!(:account) { create(:account) }
      let(:number) { account.number }
      subject { described_class.debit(number, 100) }

      it 'should balance to equal `100.0`' do
        expect(subject.balance).to eq(100.0)
      end

      it 'should change Transactions count' do
        expect { subject }.to change { Transaction.count }
      end

      context 'when account not found' do
        let(:number) { 'number' }

        it 'should raise AccountService::Errors::NotFound' do
          expect { subject }.to raise_error(AccountService::Errors::NotFound)
        end
      end

      context 'when account is blocked' do
        let!(:account) { create(:account, blocked: true) }

        it 'should raise AccountService::Errors::Blocked' do
          expect { subject }.to raise_error(AccountService::Errors::Blocked)
        end
      end
    end

    describe '#credit' do
      let!(:account) { create(:account, balance: balance) }
      let(:balance) { 200 }
      let(:number) { account.number }
      subject { described_class.credit(number, 100) }

      it 'should balance to equal `100.0`' do
        expect(subject.balance).to eq(100.0)
      end

      it 'should change Transactions count' do
        expect { subject }.to change { Transaction.count }
      end

      context 'when account not found' do
        let(:number) { 'number' }

        it 'should raise AccountService::Errors::NotFound' do
          expect { subject }.to raise_error(AccountService::Errors::NotFound)
        end
      end

      context 'when insufficient funds on account' do
        let(:balance) { 50 }

        it 'should raise AccountService::Errors::InsufficientFunds' do
          expect { subject }.to raise_error(AccountService::Errors::InsufficientFunds)
        end
      end

      context 'when account is blocked' do
        let!(:account) { create(:account, blocked: true) }

        it 'should raise AccountService::Errors::Blocked' do
          expect { subject }.to raise_error(AccountService::Errors::Blocked)
        end
      end
    end

    describe '#transfer' do
      let!(:account_from) { create(:account, balance: balance) }
      let!(:account_to) { create(:account, number: '2' * 20) }
      let(:balance) { 200 }
      let(:from) { account_from.number }
      let(:to) { account_to.number }
      subject { described_class.transfer(from, to, 100) }

      it 'should account_from balance change to `100.0`' do
        expect { subject }.to change { account_from.reload.balance }.from(200.0).to(100.0)
      end

      it 'should account_to balance change to `100.0`' do
        expect { subject }.to change { account_to.reload.balance }.from(0.0).to(100.0)
      end

      it 'should change Transactions count' do
        expect { subject }.to change { Transaction.count }
      end

      context 'when account_from not found' do
        let(:from) { 'number' }

        it 'should raise AccountService::Errors::NotFound' do
          expect { subject }.to raise_error(AccountService::Errors::NotFound)
        end
      end

      context 'when account_from is blocked' do
        let!(:account_from) { create(:account, blocked: true) }

        it 'should raise AccountService::Errors::Blocked' do
          expect { subject }.to raise_error(AccountService::Errors::Blocked)
        end
      end

      context 'when account_from not found' do
        let(:to) { 'number' }

        it 'should raise AccountService::Errors::NotFound' do
          expect { subject }.to raise_error(AccountService::Errors::NotFound)
        end
      end

      context 'when account_to is blocked' do
        let!(:account_to) { create(:account, blocked: true) }

        it 'should raise AccountService::Errors::Blocked' do
          expect { subject }.to raise_error(AccountService::Errors::Blocked)
        end
      end

      context 'when insufficient funds on account from' do
        let(:balance) { 50 }

        it 'should raise AccountService::Errors::InsufficientFunds' do
          expect { subject }.to raise_error(AccountService::Errors::InsufficientFunds)
        end
      end
    end

    describe '#turnover' do
      let!(:account) { create(:account, balance: 200) }
      let(:number) { account.number }
      let(:account_id) { account.id }
      let!(:debit) { create(:transaction, type_operation: 'debit', amount: 300, account_id: account_id) }
      let!(:credit) { create(:transaction, type_operation: 'credit', amount: 100, account_id: account_id) }
      let(:date) { Time.now.strftime('%Y-%m-%d') }
      subject { described_class.turnover(number, date, date) }

      it { is_expected.to be_a(Hash) }

      it 'should result include `debit`' do
        expect(subject['debit'].first['id']).to eq(debit.id)
      end

      it 'should result include `credit`' do
        expect(subject['credit'].first['id']).to eq(credit.id)
      end

      context 'when account not found' do
        let(:number) { 'number' }

        it 'should raise AccountService::Errors::NotFound' do
          expect { subject }.to raise_error(AccountService::Errors::NotFound)
        end
      end
    end
  end
end
