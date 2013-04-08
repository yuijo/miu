require 'spec_helper'
require 'celluloid/zmq'

describe Miu::Publisher do
  shared_examples 'writable socket' do
    let(:pub) { Miu::Publisher.new(:socket => base) }

    it { expect(pub).to be_kind_of(base) }
    it { expect(pub).to be_kind_of(Miu::Writable) }
    it { expect(pub).to be_kind_of(Miu::Publisher) }
    it { expect(pub).to be_respond_to(:connect, :write) }
  end

  context 'miu socket' do
    it_should_behave_like 'writable socket' do
      let(:base) { Miu::PubSocket }
    end
  end

  context 'celluloid/zmq socket' do
    it_should_behave_like 'writable socket' do
      let(:base) { Celluloid::ZMQ::PubSocket }
    end
  end

  context 'other socket' do
    class MyPubSocket
      def connect(address); end
      def write; end
    end

    it_should_behave_like 'writable socket' do
      let(:base) { MyPubSocket }
    end
  end
end
