# frozen_string_literal: true

require 'legion/extensions/mongodb/helpers/client'

module Legion
  module Extensions
    module Mongodb
      module Runners
        module Documents
          def find(collection:, filter: {}, limit: 0, **)
            cursor = client(**).use(database(**))
                               .collection(collection)
                               .find(filter)
            cursor = cursor.limit(limit) if limit.positive?
            { result: cursor.to_a }
          end

          def insert_one(collection:, document:, **)
            result = client(**).use(database(**)).collection(collection).insert_one(document)
            { result: result.inserted_id }
          end

          def insert_many(collection:, documents:, **)
            result = client(**).use(database(**)).collection(collection).insert_many(documents)
            { result: result.inserted_ids }
          end

          def update_one(collection:, filter:, update:, upsert: false, **)
            result = client(**).use(database(**)).collection(collection)
                               .update_one(filter, { '$set' => update }, upsert: upsert)
            { result: result.modified_count }
          end

          def delete_one(collection:, filter:, **)
            result = client(**).use(database(**)).collection(collection).delete_one(filter)
            { result: result.deleted_count }
          end

          def count(collection:, filter: {}, **)
            result = client(**).use(database(**)).collection(collection).count_documents(filter)
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
