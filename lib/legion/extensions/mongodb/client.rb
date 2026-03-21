# frozen_string_literal: true

require_relative 'helpers/client'
require_relative 'runners/documents'
require_relative 'runners/collections'

module Legion
  module Extensions
    module Mongodb
      class Client
        include Runners::Documents
        include Runners::Collections

        attr_reader :opts

        def initialize(uri: 'mongodb://127.0.0.1:27017', database: 'legion', **extra)
          @opts = { uri: uri, database: database, **extra }
        end

        def client(**override)
          Helpers::Client.client(**@opts, **override)
        end

        def database(**override)
          override[:database] || @opts[:database] || 'legion'
        end
      end
    end
  end
end
