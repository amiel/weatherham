require 'spec_helper'

describe ObservationsController do
  subject { response }

  describe '#index' do
    let(:response) { get :index }

    it { should be_success }
  end
end
