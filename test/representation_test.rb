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

      before do
        context.expect(:polymorphic_url, '/self', [record])
      end

      it 'returns a Hash with the name of each link and its url' do
        Representation.link(:comment)

        context.expect(:polymorphic_url, '/path/to/comment', ['Comment'])
        representation.links[:comment].must_equal '/path/to/comment'
      end

      it 'always includes a link to self' do
        representation.links[:self].must_equal '/self'
      end

      it 'handles blocks' do
        context.expect(:url_for, '/path/to/comment', [record])

        Representation.link :custom_comment do |record, context|
          context.url_for(record)
        end
        representation.links[:custom_comment].must_equal '/path/to/comment'
      end

      describe 'with :if' do
        it 'includes the link if the condition is truthy' do
          record.valid = true
          Representation.link :comment, if: proc { record.valid }

          context.expect(:polymorphic_url, '/path/to/comment', ['Comment'])
          representation.links[:comment].must_equal '/path/to/comment'
        end

        it 'does not include the link if the condition is falsy' do
          record.valid = false
          Representation.link :comment, if: proc { record.valid }

          representation.links.wont_include :comment
        end
      end

      after do
        context.verify
        Representation.class_variable_set(:@@links, [])
      end
    end

    describe 'embedded' do
      let(:record) { MiniTest::Mock.new }

      it 'returns a Hash with the name of each embedded resource' do
        Representation.embed(:author)

        record.expect(:send, {name: 'Joe'}, [:author])
        representation.embedded[:author].must_equal({name: 'Joe'})
      end

      it 'handles blocks' do
        record.expect(:custom_author, {name: 'Bob'})

        Representation.embed :custom_author do |record, context|
          record.custom_author
        end

        representation.embedded[:custom_author].must_equal({name: 'Bob'})
      end

      it 'creates new Representations for each embedded resource'

      after do
        record.verify
        Representation.class_variable_set(:@@embeds, [])
      end
    end
  end
end
