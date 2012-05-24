require 'hypermodel/resource'
require 'hypermodel/traverse_ancestors'

module Hypermodel
  # Public: Commands a collection of resources to build themselves in JSON-HAL
  # format, with some links of the collection itself.
  class Collection
    # Public: Initializes a Collection.
    #
    # collection - An Array of Mongoid documents.
    # controller - An ActionController instance.
    #
    # Returns nothing.
    def initialize(collection, controller)
      @collection = collection
      @name       = collection.first.class.name.downcase.pluralize
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
    def links
      _links = parent_link.update({
        self: { href: @controller.polymorphic_url(collection_hierarchy) }
      })

      { _links: _links }
    end

    # Internal: Constructs the _embedded section of the response.
    #
    # Returns a Hash of the collection members, decorated as Resources.
    def embedded
      {
        _embedded: {
          @name => decorated_collection
        }
      }
    end

    #######
    private
    #######

    # Internal: Returns a Hash with a link to the parent of the collection, if
    # it exists, or an empty Hash otherwise.
    def parent_link
      link = {}
      if collection_hierarchy.length > 1
        parent_name = collection_hierarchy[-2].class.name.downcase
        link[parent_name] = {
          href: @controller.polymorphic_url(collection_hierarchy[0..-2])
        }
      end
      link
    end

    # Internal: Returns a copy of the collection with its members decorated as
    # Hypermodel Resources.
    def decorated_collection
      @collection.map do |element|
        Resource.new(element, @controller)
      end
    end

    # Internal: Returns an Array with the ancestor hierarchy of the
    # collection, used mainly to construct URIs.
    #
    # The last element is always the plural name of the collection as a String.
    #
    # Examples
    #
    #   collection = Hypermodel::Collection.new(post.comments)
    #   collection.send :collection_hierarchy
    #   # => [#<Blog:0x123456>, #<Post:0x456789>, "comments"]
    #
    def collection_hierarchy
      @collection_hierarchy ||= 
        TraverseAncestors[@collection.first][0..-2].tap do |fields|
          fields << @name
        end
    end
  end
end
