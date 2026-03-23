# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.2] - 2026-03-22

### Changed
- Add legion-cache, legion-crypt, legion-data, legion-json, legion-logging, legion-settings, and legion-transport as runtime dependencies
- Update spec_helper with real sub-gem helper stubs (Legion::Extensions::Helpers::Lex backed by real helpers)

## [0.1.0] - 2026-03-21

### Added
- Initial release
- `Helpers::Client` module with `Mongo::Client` connection builder (uri, database)
- `Runners::Documents` with find, insert_one, insert_many, update_one, delete_one, count
- `Runners::Collections` with list_collections, create_collection, drop_collection, collection_stats
- Standalone `Client` class including all runner modules
- Full spec coverage (17 specs)
