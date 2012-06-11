require 'fast_test_helper'
require 'hypermodel/link_builder'

module Hypermodel
  describe LinkBuilder do
    let(:context)  { MiniTest::Mock.new }
    let(:record)   { MiniTest::Mock.new }
    let(:builder)  { LinkBuilder.new(record, context, []) }

    describe 'links' do
      it 'always includes a link to self' do
      end
    end
  end
end
