require 'spec_helper'
require 'celluloid/zmq'

describe Miu::Subscriber do
  context 'miu socket' do
    it_should_behave_like 'subscribable socket' do
      let(:base) { Miu::SubSocket }
    end
  end

  context 'celluloid/zmq socket' do
    it_should_behave_like 'subscribable socket' do
      let(:base) { Celluloid::ZMQ::SubSocket }
    end
  end

  context 'other socket' do
    class MySubSocket
      def connect(address); end
      def read; end
    end

    it_should_behave_like 'subscribable socket' do
      let(:base) { MySubSocket }
    end
  end

  context 'include' do
    before do
      subscriber = stub(Miu::Subscriber)
      subscriber.stub(:subscribe)
      subscriber.stub(:unsubscribe)
      Miu::Subscriber.stub!(:new).and_return(subscriber)

      @klass = Class.new do
        include Miu::Subscriber
        socket_type Miu::SubSocket
      end
    end

    describe '#socket_type' do
      it { expect(@klass.socket_type).to eq Miu::SubSocket }
    end

    describe '#method_name' do
      let(:subscriber) { @klass.new 'dummy', 1234, 'tag' }
      it { expect(subscriber.__send__ :method_name, Miu::Packet.new('tag', Miu::Messages::Text.new)).to eq 'on_text' }
      it { expect(subscriber.__send__ :method_name, Miu::Packet.new('tag', Miu::Messages::Enter.new)).to eq 'on_enter' }
      it { expect(subscriber.__send__ :method_name, Miu::Packet.new('tag', Miu::Messages::Leave.new)).to eq 'on_leave' }
    end
  end
end
