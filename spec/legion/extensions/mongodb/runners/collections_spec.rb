# frozen_string_literal: true

require 'spec_helper'
require 'legion/extensions/mongodb/helpers/client'
require 'legion/extensions/mongodb/runners/collections'

RSpec.describe Legion::Extensions::Mongodb::Runners::Collections do
  let(:mock_mongo) { double('MongoClient') }
  let(:mock_db)    { double('MongoDatabase') }
  let(:mock_coll)  { double('MongoCollection') }

  let(:runner_class) do
    mc = mock_mongo
    Class.new do
      include Legion::Extensions::Mongodb::Runners::Collections

      define_method(:client) { |**_opts| mc }
    end
  end

  let(:runner) { runner_class.new }

  before do
    allow(mock_mongo).to receive(:use).and_return(mock_db)
    allow(mock_db).to receive(:collection).and_return(mock_coll)
  end

  describe '#list_collections' do
    it 'returns collection names as an array' do
      cursor = [{ 'name' => 'users' }, { 'name' => 'logs' }]
      allow(mock_db).to receive(:list_collections).and_return(cursor)

      result = runner.list_collections
      expect(result[:result]).to eq(%w[users logs])
    end

    it 'returns an empty array when there are no collections' do
      allow(mock_db).to receive(:list_collections).and_return([])

      result = runner.list_collections
      expect(result[:result]).to eq([])
    end
  end

  describe '#create_collection' do
    it 'returns the collection name' do
      allow(mock_db).to receive(:command).with(create: 'events').and_return(double('CommandResult'))

      result = runner.create_collection(collection: 'events')
      expect(result[:result]).to eq('events')
    end

    it 'issues the create command to the database' do
      cmd_result = double('CommandResult')
      allow(mock_db).to receive(:command).with(create: 'metrics').and_return(cmd_result)

      runner.create_collection(collection: 'metrics')
      expect(mock_db).to have_received(:command).with(create: 'metrics')
    end
  end

  describe '#drop_collection' do
    it 'returns the collection name' do
      allow(mock_coll).to receive(:drop)

      result = runner.drop_collection(collection: 'old_logs')
      expect(result[:result]).to eq('old_logs')
    end

    it 'calls drop on the collection' do
      allow(mock_coll).to receive(:drop)

      runner.drop_collection(collection: 'old_logs')
      expect(mock_coll).to have_received(:drop)
    end
  end

  describe '#collection_stats' do
    it 'returns collection statistics' do
      stats = { 'ns' => 'mydb.users', 'count' => 100 }
      cmd_result = double('CommandResult', documents: [stats])
      allow(mock_db).to receive(:command).with(collStats: 'users').and_return(cmd_result)

      result = runner.collection_stats(collection: 'users')
      expect(result[:result]).to eq(stats)
    end
  end
end
