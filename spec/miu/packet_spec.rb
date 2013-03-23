require 'spec_helper'

describe Miu::Packet do
  describe '#initialize' do
    before { @packet = Miu::Packet.new 'tag', 'message' }
    subject { @packet }

    its(:tag) { should eq 'tag' }
    its(:message) { should eq 'message' }
  end

  describe '#dump' do
    before { @packet = Miu::Packet.new 'tag', 'message' }
    subject { @packet.dump }

    it { should be_instance_of Array }
    it { should have(2).values }
    its([0]) { should be_instance_of String }
    its([1]) { should be_instance_of String }
  end

  describe '#load' do
    before do
      @packet = Miu::Packet.new 'tag', 'message'
      @dumped = @packet.dump
    end

    it 'load succeeded' do
      expect { Miu::Packet.load @dumped }.to_not raise_error
    end

    context 'attributes' do
      before { @loaded = Miu::Packet.load @dumped }
      subject { @loaded }

      its(:tag) { should eq @packet.tag }
      its(:message) { should eq @packet.message }
    end
  end

  describe '#inspect' do
    let(:str) { Miu::Packet.new('tag', 'message').inspect }

    it { expect(str).to be_instance_of String }
    it { expect(str).to match /^#<Miu::Packet .*>$/ }
  end
end
