# lex-mongodb

LegionIO extension connecting LegionIO to MongoDB. Provides runners for document operations
and collection management.

## Installation

Add to your Gemfile:

```ruby
gem 'lex-mongodb'
```

## Standalone Client Usage

```ruby
require 'legion/extensions/mongodb'

client = Legion::Extensions::Mongodb::Client.new(
  uri: 'mongodb://localhost:27017',
  database: 'myapp'
)

# Insert a document
client.insert_one(collection: 'users', document: { name: 'Jane Doe', role: 'admin' })

# Find documents
result = client.find(collection: 'users', filter: { role: 'admin' })
puts result[:result]

# Insert multiple documents
client.insert_many(
  collection: 'logs',
  documents: [{ event: 'login' }, { event: 'logout' }]
)

# Update a document
client.update_one(
  collection: 'users',
  filter: { name: 'Jane Doe' },
  update: { role: 'superadmin' }
)

# Delete a document
client.delete_one(collection: 'users', filter: { name: 'Jane Doe' })

# Count documents matching a filter
result = client.count(collection: 'users', filter: { role: 'admin' })
puts result[:result]

# List collections
result = client.list_collections
puts result[:result]

# Create a collection
client.create_collection(collection: 'events')

# Drop a collection
client.drop_collection(collection: 'events')

# Get collection stats
result = client.collection_stats(collection: 'users')
puts result[:result]
```

## Configuration

| Setting | Default | Description |
|---------|---------|-------------|
| `uri` | `mongodb://127.0.0.1:27017` | MongoDB connection URI |
| `database` | `legion` | Default database name |

## License

MIT
