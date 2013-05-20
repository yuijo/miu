require 'spec_helper'

describe Miu::Readable do
  class MySocket
    def read; end
    include Miu::Readable
  end

  let(:socket) { MySocket.new }

  it { expect(socket).to be_respond_to :read }
  it { expect(socket).to be_respond_to :read_with_packet }
  it { expect(socket).to be_respond_to :read_without_packet }

  it { expect(socket).to be_kind_of ::Enumerable }
  it { expect(socket).to be_respond_to :each }

  describe '#read' do
    before do
      socket.stub(:read_without_packet).and_return(topic, data.to_msgpack)
      socket.stub(:more_parts?).and_return(true, false)
    end

    context 'invalid data' do
      let(:topic) { 'topic' }
      let(:data) { 'data' }
      let(:packet) { socket.read }

      it { expect(packet.topic).to eq 'topic' }
      it { expect(packet.data).to be_instance_of Miu::Messages::Unknown }
      it { expect(packet.data.content).to eq 'data' }
    end

    context 'valid data' do
      let(:topic) { 'topic' }
      let(:data) { Miu::Messages::Text.new(:content => {:text => 'test'}) }
      let(:packet) { socket.read }

      it { expect(packet.topic).to eq 'topic' }
      it { expect(packet.data).to be_instance_of Miu::Messages::Text }
      it { expect(packet.data.content.text).to eq 'test' }
    end
  end
end
