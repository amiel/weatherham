require 'spec_helper'

describe Fetch do
  describe '#start!' do
    it 'returns a fetch' do
      BellinghamColdstorage.stub(:gather!)
      Fetch.start!.should be_kind_of(Fetch)
    end
  end
end
