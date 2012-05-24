require 'hypermodel/serializers/mongoid'

module Hypermodel
  # Private: Responsible for instantiating the correct serializer for a given
  # record. Right now only works with Mongoid.
  class Serializer

    # Public: Returns a matching Serializer inspecting the ORM of the record.
    def self.build(record)
      Serializers::Mongoid.new(record)
    end
  end
end
