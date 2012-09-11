task gather: :environment do
  BellinghamColdstorage.gather!
end

# task compress: :environment do
#   ObservationCompressor.run!
# end
