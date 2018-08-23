# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GraphqlController, type: :controller do

  context 'GET #execute' do
    subject { post :execute }
    it { is_expected.to be_ok }
  end
end
