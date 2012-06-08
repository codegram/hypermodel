class EmbedBuilder
  def initialize(record, context, embeds)
    @record  = record
    @context = context
    @embeds = embeds
  end

  def embedded
    @embeds.inject({}) do |embedded, (name, options, block)|
      # next embedded if should_skip(options)

      value = if block
                block.call(@record, @context)
              else
                @record.send(name)
              end
      embedded.update(name => value)
    end
  end
end
