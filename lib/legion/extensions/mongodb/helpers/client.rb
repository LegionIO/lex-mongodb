# frozen_string_literal: true

require 'mongo'

module Legion
  module Extensions
    module Mongodb
      module Helpers
        module Client
          def self.client(uri: 'mongodb://127.0.0.1:27017', database: 'legion', **_opts)
            ::Mongo::Client.new(uri, database: database)
          end
        end
      end
    end
  end
end
