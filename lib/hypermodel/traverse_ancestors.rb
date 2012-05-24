require 'hypermodel/serializers/mongoid'

module Hypermodel
    # Public: Recursive function that traverses a record's referential
    # hierarchy upwards.
    #
    # Returns a flattened Array with the hierarchy of records.
    TraverseAncestors = lambda do |record|
      serializer = Serializers::Mongoid.new(record)

      parent_name, parent_resource = (
        serializer.embedding_resources.first || serializer.resources.first
      )

      # If we have a parent
      if parent_resource
        # Recurse over parent hierarchies
        [TraverseAncestors[parent_resource], record].flatten
      else
        # Final case, we are the topmost parent: return ourselves
        [record]
      end
    end
end
