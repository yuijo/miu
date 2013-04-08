require 'spec_helper'

describe Miu::Writable do
  class MySocket
    def write; end
    include Miu::Writable
  end

  let(:socket) { MySocket.new }

  it { expect(socket).to be_respond_to :write }
  it { expect(socket).to be_respond_to :write_with_packet }
  it { expect(socket).to be_respond_to :write_without_packet }

  describe '#write' do
    let(:tag) { 'tag' }
    let(:msg) { 'msg' }

    it do
      socket.should_receive(:write_without_packet)
      expect(socket.write tag, msg).to be_instance_of Miu::Packet
    end
  end
end
