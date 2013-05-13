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

  context 'include' do
    before do
      publisher = stub(Miu::Publisher)
      Miu::Publisher.stub!(:new).and_return(publisher)

      @klass = Class.new do
        include Miu::Publisher
        socket_type Miu::PubSocket
      end
    end

    describe '#socket_type' do
      it { expect(@klass.socket_type).to eq Miu::PubSocket }
    end
  end
end
