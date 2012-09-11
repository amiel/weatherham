require_relative '../../lib/bellingham_coldstorage'
require 'ostruct'
require 'active_support/time'

describe BellinghamColdstorage do
  before { Time.zone = 'Pacific Time (US & Canada)' }

  describe '.parse_weather' do

#                   Temp     Hi    Low   Out    Dew  Wind  Wind   Wind    Hi    Hi   Wind   Heat    THW                Rain    Heat    Cool    In     In    In     In   Wind  Wind    ISS   Arc.
#   Date    Time     Out   Temp   Temp   Hum    Pt. Speed   Dir    Run Speed   Dir  Chill  Index  Index   Bar    Rain  Rate    D-D     D-D    Temp   Hum    Dew   Heat  Samp   Tx   Recept  Int.
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    context 'with an example line' do
      let(:input) { ' 9/03/12 12:05a   56.8   56.9   56.8    80   50.7   0.0   ---   0.00   0.0   ---   56.8   56.5   56.5  30.110  0.00  0.00   0.028   0.000   79.5    36   50.2   78.2   118    1    100.0    5 '}
      let(:result) { BellinghamColdstorage.parse_weather input }
      subject { OpenStruct.new result } # Just for easier assertions

      its(:observed_at) { should == Time.zone.parse('2012-09-03 12:05am') }
    end
  end
end
