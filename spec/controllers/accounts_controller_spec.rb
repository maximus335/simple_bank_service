# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  let!(:account) { create(:account) }

  context 'GET #index' do
    subject { get :index }
    it { is_expected.to be_ok }
  end

  context 'GET #open' do
    subject { get :open }
    it { is_expected.to be_ok }
  end

  context 'GET #balance' do
    subject { get :balance, params: params }
    let(:params) { { number: account.number } }
    it { is_expected.to be_ok }
  end

  context 'GET #balance_by_date' do
    subject { get :balance_by_date, params: params }
    let(:params) { { number: account.number, date: '2018-01-01' } }
    it { is_expected.to be_ok }
  end

  context 'GET #debit' do
    subject { get :debit, params: params }
    let(:params) { { number: account.number, amount: '100' } }
    it { is_expected.to be_ok }
  end

  context 'GET #credit' do
    let!(:account) { create(:account, balance: 1000) }
    subject { get :credit, params: params }
    let(:params) { { number: account.number, amount: '100' } }
    it { is_expected.to be_ok }
  end

  context 'GET #transfer' do
    let!(:account_from) { create(:account, number: '2' * 20, balance: 1000) }
    let!(:account_to) { create(:account, number: '3' * 20) }
    subject { get :transfer, params: params }
    let(:params) { { from: account_from.number, to: account_to.number, amount: '100' } }
    it { is_expected.to be_ok }
  end

  context 'GET #turnover' do
    subject { get :turnover, params: params }
    let(:params) { { number: account.number, date_start: '2018-01-01', date_finish: '2018-02-01' } }
    it { is_expected.to be_ok }
  end
end
