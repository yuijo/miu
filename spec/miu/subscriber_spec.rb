require 'spec_helper'

describe Miu::Subscriber do
  let(:sub) { Miu::Subscriber.new }

  describe '#subscribe' do
    it 'call once' do
      sub.should_not_receive(:unsubscribe)
      expect(sub.subscribe).to be_empty
    end

    it 'call twice' do
      sub.should_receive(:unsubscribe).once
      expect(sub.subscribe('aaa')).to eq 'aaa'
      expect(sub.subscribe('bbb')).to eq 'bbb'
    end
  end

  describe '#recv' do
    let(:tag) { 'tag' }
    let(:data) { {:type => 'test' } }

    before do
      sub.socket.stub(:recv_strings)
      Miu::Packet.stub(:load).and_return(Miu::Packet.new(tag, data))
    end

    it { expect { sub.recv }.to_not raise_error(Miu::MessageLoadError) }

    let(:packet) { sub.recv }
    it { expect(packet.tag).to eq tag }
    it { expect(packet.data).to be_kind_of Miu::Messages::Base }
  end

  describe '#each' do
    it do
      sub.stub(:recv).and_return(1, 2, 3)
      sub.stub(:recv).and_throw(:stop)
      expect {
        expect { |b| sub.each(&b) }.to yield_successive_args(1, 2, 3)
      }.to throw_symbol(:stop)
    end
  end
end
