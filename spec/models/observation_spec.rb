require 'spec_helper'

describe Observation do
  subject { Observation }

  context 'with no observations' do
    before { Observation.stub(any?: false) }
    it { should be_need_fetch }
  end

  # context 'with same datas' do
  #   fixtures :observations
  #   it { should_not be_need_fetch }
  # end
end
