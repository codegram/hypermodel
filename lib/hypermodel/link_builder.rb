class LinkBuilder
  def initialize(record, context, links)
    @record  = record
    @context = context
    @links = links
  end

  def links
    link_to_self = LinkToSelf.new(@record, @context, :self).to_hash

    @links.inject(link_to_self) do |links, (name, options, block)|
      link = Link.new(@record, @context, name, options, &block)
      next links if link.skip?
      links.update(link.to_hash)
    end
  end
end

require_relative 'link'
