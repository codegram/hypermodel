require 'hypermodel/resource'

module Hypermodel
  # Public: Represents an empty Collection.
  #
  # FIXME: LET THIS BURN IN HELL FOR ALL ETERNITY
  class EmptyCollection
    # Public: Initializes a Collection.
    #
    # collection - An Array of Mongoid documents.
    # controller - An ActionController instance.
    #
    # Returns nothing.
    def initialize(resource_name, controller)
      @name       = resource_name
      @controller = controller
    end

    # Public: Serialize the whole representation as JSON.
    #
    # Returns a String with the serialization.
    def as_json(*opts)
      links.update(embedded).as_json(*opts)
    end

    # Internal: Constructs the _links section of the response.
    #
    # Returns a Hash of the links of the collection. It will include, at least,
    # a link to itself.
    #
    # TODO: Discover parents and include them in _links.
    def links
      _links = {
        self: { href: @controller.polymorphic_url(collection_hierarchy) }
      }

      { _links: _links }
    end

    def embedded
      { _embedded: { @name => [] } }
    end

    #######
    private
    #######

    def collection_hierarchy
      params = @controller.params.select { |k, v| k =~ /_id/ }

      traverse = lambda do |name|
        klass = self.class.const_get(name.singularize.capitalize)
        assoc = klass.associations.detect do |name, metadata|
          types = [Mongoid::Relations::Embedded::In, Mongoid::Relations::Referenced::In]
          params["#{name}_id"] && types.include?(metadata.relation)
        end

        if assoc
          parent_id = params["#{assoc.first}_id"]
          parent_name = assoc.first

          id = params["#{name}_id"]
          object = id ? self.class.const_get(name.singularize.capitalize).find(id) : name

          parent = self.class.const_get(parent_name.capitalize).find(parent_id)
          [traverse[parent_name], object].flatten
        else
          id = params["#{name}_id"]
          object = self.class.const_get(name.capitalize).find(id)
          [object]
        end
      end

      traverse[@name]
    end
  end
end

