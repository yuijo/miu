require 'spec_helper'

describe Miu::Subscriber do
  context 'default socket' do
    let(:sub) { Miu::Subscriber.new }

    it { expect(sub).to be_kind_of(Miu::SubSocket) }
    it { expect(sub).to be_kind_of(Miu::Subscribable) }
    it { expect(sub).to be_kind_of(Miu::Subscriber) }
    it { expect(sub).to be_respond_to(:connect, :read) }
  end

  context 'other socket' do
    class MySubSocket
      def connect(host, port); end
      def read; end
    end

    let(:sub) { Miu::Subscriber.new(:socket => MySubSocket) }

    it { expect(sub).to be_kind_of(MySubSocket) }
    it { expect(sub).to be_kind_of(Miu::Subscribable) }
    it { expect(sub).to be_kind_of(Miu::Subscriber) }
    it { expect(sub).to be_respond_to(:connect, :read) }
  end
end
