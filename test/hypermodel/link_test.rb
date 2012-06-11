require 'fast_test_helper'
require 'hypermodel/link'

module Hypermodel
  describe Link do
    let(:context) { MiniTest::Mock.new }
    let(:record)  { MiniTest::Mock.new }
    let(:link)    { Link.new(record, context, 'link') }

    describe 'link' do
      it 'gets the url from the context' do
        record.expect(:send, 'comment', ['link'])
        context.expect(:polymorphic_url, '/path/to/resource', ['comment'])

        link.link.must_equal '/path/to/resource'
      end

      it 'gets the url from the block when one given' do
        record.expect(:comment, 'comment')
        link = Link.new(record, context, 'link') do |record, context|
          record.comment
        end

        link.link.must_equal 'comment'
      end
    end

    describe 'skip?' do
      it 'returns false if no conditional given' do
        link.skip?.must_equal false
      end

      it 'returns false if conditional given but nil' do
        link = Link.new(record, context, 'link', {if: nil})
        link.skip?.must_equal false
      end

      it 'checks if the conditional applies' do
        record.expect(:valid?, false)
        conditional = Proc.new do |record, context|
          record.valid?
        end
        link = Link.new(record, context, 'link', {if: conditional})

        link.skip?.must_equal true
      end
    end

    describe 'to_hash' do
      it 'returns a hash with the name and the link' do
        link = Link.new(record, context, 'link') do |record, context|
          '/path/to/resource'
        end

        link.to_hash.must_equal({'link' => '/path/to/resource'})
      end
    end

    after do
      record.verify
      context.verify
    end
  end
end
