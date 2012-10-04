require 'spec_helper'

describe Observation do
  subject { Observation }

  context 'with no observations' do
    before { Observation.stub(any?: false) }
    it { should be_need_fetch }
  end


  context 'with same datas' do
    fixtures :observations

    it { should be_need_fetch }
    context 'and there is a recent observation' do
      before { Observation.create observed_at: Time.current }

      it { should_not be_need_fetch }
    end

    context 'and there are 10 more than 9000 of them' do
      before { Observation.stub(count: 9010) }

      describe '.prune!' do
        it 'removes 10 observations' do
          # Select to bypass stub
          initial_count = Observation.select('id').count

          last_observation = Observation.last
          observations_to_delete = Observation.limit(10).all

          expect {
            Observation.prune!
            Observation.last.should == last_observation
            observations_to_delete.each do |o|
              expect {
                o.reload
              }.to raise_error(ActiveRecord::RecordNotFound)
            end
          }.to change(Observation.select('id'), :count).by(-10)
        end
      end
    end
  end
end
