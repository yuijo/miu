require 'spec_helper'
require 'celluloid/zmq'

describe Miu::Publisher do
  context 'miu socket' do
    it_should_behave_like 'publishable socket' do
      let(:base) { Miu::PubSocket }
    end
  end

  context 'celluloid/zmq socket' do
    it_should_behave_like 'publishable socket' do
      let(:base) { Celluloid::ZMQ::PubSocket }
    end
  end

  context 'other socket' do
    class MyPubSocket
      def connect(address); end
      def write; end
    end

    it_should_behave_like 'publishable socket' do
      let(:base) { MyPubSocket }
    end
  end
end
