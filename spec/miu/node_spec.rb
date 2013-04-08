require 'spec_helper'

describe Miu::Node do
  def create_node_class
    Class.new do
      include Miu::Node
    end
  end

  describe 'description' do
    it do
      MiuNodeDescriptionTest = create_node_class
      expect(MiuNodeDescriptionTest.description).to eq MiuNodeDescriptionTest.name
    end

    it do
      c = create_node_class
      c.description 'my node'
      expect(c.description).to eq 'my node'
    end
  end

  describe 'register' do
    it do
      c = create_node_class
      block = proc {}
      Miu.should_receive(:register).with('test', c, {}, &block)
      c.register 'test', &block
    end
  end
end
