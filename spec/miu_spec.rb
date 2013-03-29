require 'spec_helper'

describe Miu do
  describe 'root' do
    before { Dir.chdir '/tmp' }
    let(:root) { Miu.root }
    it { expect(root).to be_instance_of Pathname }
    it { expect(root.to_s).to eq '/tmp' }
  end

  describe 'default_port' do
    context 'default' do
      it { expect(Miu.default_port).to eq 22200 }
    end

    context 'overwrite' do
      before { ENV['MIU_DEFAULT_PORT'] = '12345' }
      it { expect(Miu.default_port).to be_instance_of Fixnum }
      it { expect(Miu.default_port).to eq 12345 }
    end
  end
end
