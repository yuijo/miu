require 'spec_helper'

describe Miu::Publisher do
  context 'default socket' do
    let(:pub) { Miu::Publisher.new }

    it { expect(pub).to be_kind_of(Miu::PubSocket) }
    it { expect(pub).to be_kind_of(Miu::Publishable) }
    it { expect(pub).to be_kind_of(Miu::Publisher) }
    it { expect(pub).to be_respond_to(:connect, :write) }
  end

  context 'other socket' do
    class MyPubSocket
      def connect(host, port); end
      def write; end
    end

    let(:pub) { Miu::Publisher.new(:socket => MyPubSocket) }

    it { expect(pub).to be_kind_of(MyPubSocket) }
    it { expect(pub).to be_kind_of(Miu::Publishable) }
    it { expect(pub).to be_kind_of(Miu::Publisher) }
    it { expect(pub).to be_respond_to(:connect, :write) }
  end
end
