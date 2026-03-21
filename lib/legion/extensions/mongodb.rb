# frozen_string_literal: true

require 'legion/extensions/mongodb/version'
require 'legion/extensions/mongodb/helpers/client'
require 'legion/extensions/mongodb/runners/documents'
require 'legion/extensions/mongodb/runners/collections'
require 'legion/extensions/mongodb/client'

module Legion
  module Extensions
    module Mongodb
      extend Legion::Extensions::Core if Legion::Extensions.const_defined?(:Core, false)
    end
  end
end
