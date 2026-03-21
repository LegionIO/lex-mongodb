# frozen_string_literal: true

require 'legion/extensions/mongodb/helpers/client'

module Legion
  module Extensions
    module Mongodb
      module Runners
        module Collections
          def list_collections(**)
            names = client(**).use(database(**)).list_collections.map { |c| c['name'] }
            { result: names }
          end

          def create_collection(collection:, **)
            client(**).use(database(**)).command(create: collection)
            { result: collection }
          end

          def drop_collection(collection:, **)
            client(**).use(database(**)).collection(collection).drop
            { result: collection }
          end

          def collection_stats(collection:, **)
            result = client(**).use(database(**)).command(collStats: collection).documents.first
            { result: result }
          end

          def database(**opts)
            opts[:database] || 'legion'
          end

          extend Legion::Extensions::Mongodb::Helpers::Client
          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)
        end
      end
    end
  end
end
