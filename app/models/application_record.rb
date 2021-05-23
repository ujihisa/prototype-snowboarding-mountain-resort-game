class ApplicationRecord < ActiveRecord::Base
  if !Rails.env.test? && ENV['SKIP_GOOGLE_CLOUD_STORAGE'] != '1' # skip during assets:precompile
    require 'google/cloud/storage'

    credentials =
      if ENV['CREDENTIALS_JSON']
        JSON.parse(ENV['CREDENTIALS_JSON'])
      else
        'devs-sandbox-5941dd8999bb.json'
      end
    storage = Google::Cloud::Storage.new(
      project_id: 'devs-sandbox',
      credentials: credentials,
    )

    BUCKET = storage.bucket('prototype-snowboarding-mountain-resort-game')
    private_constant :BUCKET

    file = BUCKET.file("#{Rails.env}.sqlite3")
    file.download("db/#{Rails.env}.sqlite3")

    after_commit :upload_sqlite3
  end

  self.abstract_class = true


  M = Mutex.new
  private_constant :M

  private def upload_sqlite3
    M.synchronize {
      BUCKET.create_file("db/#{Rails.env}.sqlite3", "#{Rails.env}.sqlite3")
    }
  end
end
