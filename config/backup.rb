# See erik.debill.org/2011/03/26/csing-backup-with-rails (yes, 'csing', not 'using')

database_yml = File.expand_path('../database.yml', __FILE__)
RAILS_ENV = ENV['RAILS_ENV'] || 'production'
puts RAILS_ENV

require 'yaml'
db_config = YAML.load_file(database_yml)

Model.new :db_backup, 'Database Backup' do 

  # The backup contains two things - all the users' photos...
  archive :files do |archive|

    if RAILS_ENV == 'development'
      archive.add '~/Work/shipping/public/system/'
    else
      archive.add '~/shipping/shared/system/'
    end
  end

  # ... and the entire database contents.
  database MySQL do |db|
    db.name     = db_config[RAILS_ENV]['database']
    db.username = db_config[RAILS_ENV]['username']
    db.password = db_config[RAILS_ENV]['password']
    db.host     = db_config[RAILS_ENV]['host']
    db.port     = db_config[RAILS_ENV]['port']
    db.skip_tables = []
  end


  compress_with Gzip

  # For now, store the backups on the local Production drive.
  # TODO: use something cloud-based. NewRelic?
  store_with Local do |local|
    local.path = if RAILS_ENV == 'development'
      "~/Work/shipping_backups"
    else 
      "~/shipping_backups"
    end
    local.keep = 3
  end
  
end