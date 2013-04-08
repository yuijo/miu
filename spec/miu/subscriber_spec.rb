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
end
