require 'hypermodel/resource'

module Hypermodel
  # Public: Represents an empty Collection.
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
    def links
      url = @controller.request.url
      url = url.split('.')[0..-2].join('.') if url =~ /\.\w+$/

      parent_url  = url.split('/')[0..-2].join('/')
      parent_name = parent_url.split('/')[0..-2].last.singularize

      _links = {
        self: { href: url },
        parent_name => { href: parent_url }
      }

      { _links: _links }
    end

    # Internal: Constructs an empty _embedded section of the response.
    #
    # Returns an empty collection.
    def embedded
      { _embedded: { @name => [] } }
    end
  end
end

