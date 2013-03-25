require 'spec_helper'

describe Miu::Publisher do
  let(:pub) { Miu::Publisher.new }

  describe '#send' do
    it do
      tag = 'tag'
      data = 'msg'

      pub.socket.should_receive(:send_strings) do |args|
        expect(args[0]).to eq tag
        expect(args[1]).to eq data.to_msgpack
      end
      expect(pub.send tag, data).to be_instance_of Miu::Packet
    end
  end
end
