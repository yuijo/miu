require 'spec_helper'

describe Miu::Command do
  describe 'new' do
    before do
      plugin = double('plugin')
      plugin.stub_chain(:spec, :full_gem_path).and_return('path/to/plugin')
      Miu.stub(:root).and_return ('path/to/root')
      @command = Miu::Command.new 'test_plugin', plugin do
        def self.hello
        end
      end
    end
    subject { @command }

    it { should be_instance_of Class }
    its(:ancestors) { should include Thor }
    its(:source_root) { should eq 'path/to/plugin' }
    its(:destination_root) { should eq 'path/to/root' }
    its(:namespace) { should eq 'test_plugin' }
    it { should respond_to :add_miu_pub_options }
    it { should respond_to :add_miu_sub_options }
    it { should respond_to :add_miu_pub_sub_options }
    it { should respond_to :hello }
  end
end
