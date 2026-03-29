# lex-mongodb: MongoDB Integration for LegionIO

**Repository Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-other/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Legion Extension that connects LegionIO to MongoDB. Provides runners for document CRUD operations and collection management.

**GitHub**: https://github.com/LegionIO/lex-mongodb
**License**: MIT
**Version**: 0.1.2

## Architecture

```
Legion::Extensions::Mongodb
├── Runners/
│   ├── Documents    # insert_one, insert_many, find, update_one, update_many, delete_one, delete_many, count
│   └── Collections  # list_collections, create_collection, drop_collection, collection_stats
├── Helpers/
│   └── Client       # Mongo::Client factory (URI + database)
└── Client           # Standalone client class (includes all runners)
```

## Key Files

| Path | Purpose |
|------|---------|
| `lib/legion/extensions/mongodb.rb` | Entry point, extension registration |
| `lib/legion/extensions/mongodb/runners/documents.rb` | Document CRUD and query runners |
| `lib/legion/extensions/mongodb/runners/collections.rb` | Collection management runners |
| `lib/legion/extensions/mongodb/helpers/client.rb` | Mongo::Client factory (URI-based connection) |
| `lib/legion/extensions/mongodb/client.rb` | Standalone Client class |

## Configuration

Default settings:
- `uri`: `mongodb://127.0.0.1:27017`
- `database`: `legion`

Pass `uri:` and `database:` at client construction to override.

## Dependencies

| Gem | Purpose |
|-----|---------|
| `mongo` (~> 2.19) | Official MongoDB Ruby driver |

## Development

28 specs total.

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)
