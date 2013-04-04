require 'spec_helper'
require 'celluloid/zmq'

describe Miu::Subscriber do
  shared_examples 'subscribable socket' do
    it { expect(sub).to be_kind_of(base) }
    it { expect(sub).to be_kind_of(Miu::Subscribable) }
    it { expect(sub).to be_kind_of(Miu::Subscriber) }
    it { expect(sub).to be_respond_to(:connect, :read) }
  end

  context 'miu socket' do
    it_should_behave_like 'subscribable socket' do
      let(:base) { Miu::SubSocket }
      let(:sub) { Miu::Subscriber.new }
    end
  end

  context 'celluloid/zmq socket' do
    it_should_behave_like 'subscribable socket' do
      let(:base) { Celluloid::ZMQ::SubSocket }
      let(:sub) { Miu::Subscriber.new(:socket => base) }
    end
  end

  context 'other socket' do
    class MySubSocket
      def connect(address); end
      def read; end
    end

    it_should_behave_like 'subscribable socket' do
      let(:base) { MySubSocket }
      let(:sub) { Miu::Subscriber.new(:socket => base) }
    end
  end
end
