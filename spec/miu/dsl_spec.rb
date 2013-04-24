require 'spec_helper'
require 'miu/dsl'

describe Miu do
  describe 'dump_cli_options' do
    let(:options) { {'--string' => 'string', '--array' => ['foo', 'bar buzz']} }
    let(:str) { Miu.dump_cli_options(options) }
    it { expect(str).to eq "--string=string --array='foo' 'bar buzz'" }
  end

  describe 'watch' do
    let(:watch) do
      Class.new do
        attr_accessor :dir, :log, :name, :group
        attr_accessor :start, :stop, :restart
      end.new
    end

    before do
      God.stub(:watch).and_yield(watch)
      Miu.watch 'test' do |w|
        expect(w).to eq watch
        w.start = 'foo'
        w.stop = 'bar', {:buzz => 123}
      end
    end

    it { expect(watch.start).to be_instance_of String }
    it { expect(watch.stop).to be_instance_of String }
  end
end
