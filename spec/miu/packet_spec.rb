require 'spec_helper'

describe Miu::Packet do
  describe '#initialize' do
    context 'with options' do
      before { @packet = Miu::Packet.new 'tag', 'body', :id => 1, :time => 2 }
      subject { @packet }

      its(:tag) { should eq 'tag' }
      its(:body) { should eq 'body' }
      its(:id) { should eq 1 }
      its(:time) { should eq 2 }
    end

    context 'without options' do
      before { @packet = Miu::Packet.new 'tag', 'body' }
      subject { @packet }

      its(:tag) { should eq 'tag' }
      its(:body) { should eq 'body' }
      its(:id) { should_not be_nil }
      its(:time) { should_not be_nil }
    end
  end

  describe '#dump' do
    before { @packet = Miu::Packet.new 'tag', 'body', :id => 1, :time => 2 }
    subject { @packet.dump }

    it { should be_instance_of Array }
    it { should have(2).values }
    its([0]) { should be_instance_of String }
    its([1]) { should be_instance_of String }
  end

  describe '#load' do
    before do
      @packet = Miu::Packet.new 'tag', 'body', :id => 1, :time => 2
      @dumped = @packet.dump
    end

    it 'load succeeded' do
      lambda { Miu::Packet.load @dumped }.should_not raise_error
    end

    context 'attributes' do
      before { @loaded = Miu::Packet.load @dumped }
      subject { @loaded }

      its(:tag) { should eq @packet.tag }
      its(:body) { should eq @packet.body }
      its(:id) { should eq @packet.id }
      its(:time) { should eq @packet.time }
    end
  end

  describe '#inspect' do
    before { @packet = Miu::Packet.new 'tag', 'body', :id => 1, :time => 2 }
    subject { @packet.inspect }

    it { should be_instance_of String }
    it { should match /^#<Miu::Packet .*>$/ }
  end
end
