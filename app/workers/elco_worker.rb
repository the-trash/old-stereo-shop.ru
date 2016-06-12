class ElcoWorker
  include Sidekiq::Worker

  sidekiq_options retry: 1, unique: true, queue: :critical

  def perform id
    elco_import = ElcoImport.find(id)
    elco_import.start_import!
  end
end
