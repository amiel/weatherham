require 'spec_helper'

describe Fetch do
  describe '#start!' do
    before { BellinghamColdstorage.stub(:gather!) }

    it 'returns a fetch' do
      BellinghamColdstorage.should_receive(:gather!)
      Fetch.start!.should be_kind_of(Fetch)
    end

    it 'removes the first fetch if there are more than 100' do
      first_fetch = mock('Fetch')
      Fetch.stub(first: first_fetch)
      first_fetch.should_receive(:destroy)

      Fetch.stub(count: 102)

      Fetch.start!
    end

    it 'does not remove any fetches when there are less than 100' do
      first_fetch = mock('Fetch')
      Fetch.stub(first: first_fetch)
      first_fetch.should_not_receive(:destroy)

      Fetch.stub(count: 99)

      Fetch.start!
    end
  end


end
