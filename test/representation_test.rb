require 'minitest/spec'
require 'minitest/autorun'
require 'hypermodel/representation'
require 'ostruct'

module Hypermodel
  describe Representation do
    let(:representation) { Representation.new(record, context) }
    let(:context) { MiniTest::Mock.new }

    describe 'initialize' do
      it 'handles collections'
    end

    describe 'attributes' do
      let(:record) { MiniTest::Mock.new }

      it 'returns a hash with only the selected attributes' do
        Representation.attributes(:name)

        record.expect(:attributes, {name: 'Foo', age: 24})
        representation.attributes.must_equal({name: 'Foo'})
      end

      after do
        record.verify
      end
    end

    describe 'links' do
      let(:record) { OpenStruct.new(comment: 'Comment') }

      it 'returns a Hash with the name of each link and its url' do
        Representation.link(:comment)

        context.expect(:polymorphic_url, '/path/to/comment', ['Comment'])
        representation.links[:comment].must_equal '/path/to/comment'
      end

      it 'includes a link to self' do
        context.expect(:polymorphic_url, '/self', [record])

        representation.links[:self].must_equal '/self'
      end

      it 'handles blocks'

      after do
        context.verify
      end
    end

    describe 'embedded' do
      let(:record) { MiniTest::Mock.new }

      it 'returns a Hash with the name of each embedded resource' do
        Representation.embed(:author)

        record.expect(:send, {name: 'Joe'}, [:author])
        representation.embedded[:author].must_equal({name: 'Joe'})
      end

      it 'creates new Representations for each embedded resource'

      after do
        record.verify
      end
    end
  end
end
