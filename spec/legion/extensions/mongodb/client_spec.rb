# frozen_string_literal: true

require 'spec_helper'
require 'legion/extensions/mongodb/client'

RSpec.describe Legion::Extensions::Mongodb::Client do
  let(:mock_mongo) { double('MongoClient') }
  let(:mock_db)    { double('MongoDatabase') }
  let(:mock_coll)  { double('MongoCollection') }

  before do
    allow(Legion::Extensions::Mongodb::Helpers::Client).to receive(:client).and_return(mock_mongo)
    allow(mock_mongo).to receive(:use).and_return(mock_db)
    allow(mock_db).to receive(:collection).and_return(mock_coll)
  end

  describe '#initialize' do
    it 'stores default options' do
      client = described_class.new
      expect(client.opts).to eq({ uri: 'mongodb://127.0.0.1:27017', database: 'legion' })
    end

    it 'accepts custom uri and database' do
      client = described_class.new(uri: 'mongodb://db.local:27017', database: 'myapp')
      expect(client.opts).to include(uri: 'mongodb://db.local:27017', database: 'myapp')
    end

    it 'passes extra kwargs into opts' do
      client = described_class.new(uri: 'mongodb://localhost:27017', database: 'test', timeout: 5)
      expect(client.opts).to include(timeout: 5)
    end
  end

  describe '#client' do
    it 'delegates to Helpers::Client.client with stored opts' do
      client = described_class.new(uri: 'mongodb://localhost:27017', database: 'test')
      result = client.client
      expect(Legion::Extensions::Mongodb::Helpers::Client).to have_received(:client)
        .with(uri: 'mongodb://localhost:27017', database: 'test')
      expect(result).to eq(mock_mongo)
    end

    it 'allows per-call overrides' do
      client = described_class.new(uri: 'mongodb://localhost:27017', database: 'prod')
      client.client(database: 'staging')
      expect(Legion::Extensions::Mongodb::Helpers::Client).to have_received(:client)
        .with(uri: 'mongodb://localhost:27017', database: 'staging')
    end
  end

  describe '#database' do
    it 'returns the configured database name' do
      client = described_class.new(database: 'mydb')
      expect(client.database).to eq('mydb')
    end

    it 'accepts an override' do
      client = described_class.new(database: 'default')
      expect(client.database(database: 'override')).to eq('override')
    end
  end

  describe 'runner modules' do
    let(:instance) { described_class.new }

    it 'responds to Documents runner methods' do
      expect(instance).to respond_to(:find, :insert_one, :insert_many, :update_one, :delete_one, :count)
    end

    it 'responds to Collections runner methods' do
      expect(instance).to respond_to(:list_collections, :create_collection, :drop_collection, :collection_stats)
    end
  end
end
