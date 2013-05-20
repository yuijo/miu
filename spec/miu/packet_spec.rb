require 'spec_helper'

describe Miu::Packet do
  describe '#initialize' do
    before { @packet = Miu::Packet.new 'topic', 'data' }
    subject { @packet }

    its(:topic) { should eq 'topic' }
    its(:data) { should eq 'data' }
  end

  describe '#dump' do
    before { @packet = Miu::Packet.new 'topic', 'data' }
    subject { @packet.dump }

    it { should be_instance_of Array }
    it { should have(2).values }
    its([0]) { should be_instance_of String }
    its([1]) { should be_instance_of String }
  end

  describe '#load' do
    before do
      @packet = Miu::Packet.new 'topic', 'data'
      @dumped = @packet.dump
    end

    it 'load succeeded' do
      expect { Miu::Packet.load @dumped }.to_not raise_error
    end

    context 'attributes' do
      before { @loaded = Miu::Packet.load @dumped }
      subject { @loaded }

      its(:topic) { should eq @packet.topic }
      its(:data) { should eq @packet.data }
    end
  end

  describe '#inspect' do
    let(:str) { Miu::Packet.new('topic', 'data').inspect }

    it { expect(str).to be_instance_of String }
    it { expect(str).to match /^#<Miu::Packet .*>$/ }
  end
end
