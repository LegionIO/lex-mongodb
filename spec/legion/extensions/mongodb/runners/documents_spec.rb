# frozen_string_literal: true

require 'spec_helper'
require 'legion/extensions/mongodb/helpers/client'
require 'legion/extensions/mongodb/runners/documents'

RSpec.describe Legion::Extensions::Mongodb::Runners::Documents do
  let(:mock_mongo) { double('MongoClient') }
  let(:mock_db)    { double('MongoDatabase') }
  let(:mock_coll)  { double('MongoCollection') }

  let(:runner_class) do
    mc = mock_mongo
    Class.new do
      include Legion::Extensions::Mongodb::Runners::Documents

      define_method(:client) { |**_opts| mc }
    end
  end

  let(:runner) { runner_class.new }

  before do
    allow(mock_mongo).to receive(:use).and_return(mock_db)
    allow(mock_db).to receive(:collection).and_return(mock_coll)
  end

  describe '#find' do
    it 'returns an array of matching documents' do
      cursor = double('Cursor', to_a: [{ '_id' => 1, 'name' => 'test' }])
      allow(mock_coll).to receive(:find).with({}).and_return(cursor)

      result = runner.find(collection: 'users')
      expect(result[:result]).to eq([{ '_id' => 1, 'name' => 'test' }])
    end

    it 'passes filter to the collection' do
      cursor = double('Cursor', to_a: [])
      allow(mock_coll).to receive(:find).with({ 'role' => 'admin' }).and_return(cursor)

      runner.find(collection: 'users', filter: { 'role' => 'admin' })
      expect(mock_coll).to have_received(:find).with({ 'role' => 'admin' })
    end

    it 'applies limit when positive' do
      cursor = double('Cursor')
      limited = double('LimitedCursor', to_a: [])
      allow(mock_coll).to receive(:find).and_return(cursor)
      allow(cursor).to receive(:limit).with(5).and_return(limited)

      runner.find(collection: 'users', limit: 5)
      expect(cursor).to have_received(:limit).with(5)
    end

    it 'does not apply limit when limit is 0' do
      cursor = double('Cursor', to_a: [])
      allow(mock_coll).to receive(:find).and_return(cursor)

      runner.find(collection: 'users', limit: 0)
      expect(cursor).not_to receive(:limit)
    end
  end

  describe '#insert_one' do
    it 'returns the inserted_id' do
      insert_result = double('InsertOneResult', inserted_id: 'abc123')
      allow(mock_coll).to receive(:insert_one).with({ 'name' => 'doc' }).and_return(insert_result)

      result = runner.insert_one(collection: 'logs', document: { 'name' => 'doc' })
      expect(result[:result]).to eq('abc123')
    end
  end

  describe '#insert_many' do
    it 'returns the inserted_ids array' do
      insert_result = double('InsertManyResult', inserted_ids: %w[id1 id2])
      docs = [{ 'a' => 1 }, { 'b' => 2 }]
      allow(mock_coll).to receive(:insert_many).with(docs).and_return(insert_result)

      result = runner.insert_many(collection: 'logs', documents: docs)
      expect(result[:result]).to eq(%w[id1 id2])
    end
  end

  describe '#update_one' do
    it 'returns the modified_count' do
      update_result = double('UpdateResult', modified_count: 1)
      allow(mock_coll).to receive(:update_one)
        .with({ '_id' => 1 }, { '$set' => { 'role' => 'admin' } }, upsert: false)
        .and_return(update_result)

      result = runner.update_one(collection: 'users', filter: { '_id' => 1 }, update: { 'role' => 'admin' })
      expect(result[:result]).to eq(1)
    end

    it 'supports upsert option' do
      update_result = double('UpdateResult', modified_count: 0)
      allow(mock_coll).to receive(:update_one)
        .with({ '_id' => 99 }, { '$set' => { 'name' => 'new' } }, upsert: true)
        .and_return(update_result)

      runner.update_one(collection: 'users', filter: { '_id' => 99 }, update: { 'name' => 'new' }, upsert: true)
      expect(mock_coll).to have_received(:update_one)
        .with({ '_id' => 99 }, { '$set' => { 'name' => 'new' } }, upsert: true)
    end
  end

  describe '#delete_one' do
    it 'returns the deleted_count' do
      delete_result = double('DeleteResult', deleted_count: 1)
      allow(mock_coll).to receive(:delete_one).with({ '_id' => 1 }).and_return(delete_result)

      result = runner.delete_one(collection: 'users', filter: { '_id' => 1 })
      expect(result[:result]).to eq(1)
    end

    it 'returns 0 when no document matched' do
      delete_result = double('DeleteResult', deleted_count: 0)
      allow(mock_coll).to receive(:delete_one).with({ '_id' => 999 }).and_return(delete_result)

      result = runner.delete_one(collection: 'users', filter: { '_id' => 999 })
      expect(result[:result]).to eq(0)
    end
  end

  describe '#count' do
    it 'returns the number of matching documents' do
      allow(mock_coll).to receive(:count_documents).with({}).and_return(42)

      result = runner.count(collection: 'users')
      expect(result[:result]).to eq(42)
    end

    it 'passes filter to count_documents' do
      allow(mock_coll).to receive(:count_documents).with({ 'active' => true }).and_return(7)

      result = runner.count(collection: 'users', filter: { 'active' => true })
      expect(result[:result]).to eq(7)
    end
  end
end
