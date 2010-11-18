ENV['RAILS_ENV'] = ENV['RAILS_ENV']
SOLR_CONFIG_PATH = "#{::Rails.root.to_s}/config/solr"
SOLR_LOGS_PATH = "#{::Rails.root.to_s}/log"
SOLR_PIDS_PATH = "#{::Rails.root.to_s}/tmp/pids/solr"

RAKER_LOGS_PATH = "#{::Rails.root.to_s}/log"
RAKER_PIDS_PATH = "#{::Rails.root.to_s}/tmp/pids/raker"

if ENV['RAILS_ENV'] == "production"
  SOLR_DATA_PATH = "#{::Rails.root.to_s}/../../shared/solr_indexes"
else
  SOLR_DATA_PATH = "#{::Rails.root.to_s}/solr_indexes"
end
