require 'spec_helper'

describe Fetch do
  describe '#start!' do
    it 'returns a fetch' do
      BellinghamColdstorage.should_receive(:gather!)
      Fetch.start!.should be_kind_of(Fetch)
    end
  end
end
