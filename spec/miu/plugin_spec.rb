require 'spec_helper'

describe Miu::Plugin do
  def create_plugin_class
    Class.new do
      include Miu::Plugin
    end
  end

  describe 'description' do
    it do
      MiuPluginDescriptionTest = create_plugin_class
      expect(MiuPluginDescriptionTest.description).to eq MiuPluginDescriptionTest.name
    end

    it do
      c = create_plugin_class
      c.description 'my plugin'
      expect(c.description).to eq 'my plugin'
    end
  end

  describe 'register' do
    it do
      c = create_plugin_class
      block = proc {}
      Miu.should_receive(:register).with('test', c, {}, &block)
      c.register 'test', &block
    end
  end
end
