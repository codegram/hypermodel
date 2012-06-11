class Link
  def initialize(record, context, name, options = {}, &block)
    @record  = record
    @context = context
    @name    = name
    @options = options
    @block   = block
  end

  def link
    return @block.call(@record, @context) if @block

    @context.polymorphic_url(@record.send(@name))
  end

  def skip?
    return false unless @options.include? :if
    return false if @options[:if] == nil

    !@options[:if].call(@record, @context)
  end

  def to_hash
    {@name => link}
  end
end

class LinkToSelf < Link
  def link
    # return @context.request.url
    # p @record.inspect
    @context.polymorphic_url(@record)
  end
end
