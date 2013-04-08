require 'spec_helper'

describe Miu::Socket do
  describe 'socket_type' do
    let(:socket_class1) { Class.new(Miu::Socket) { socket_type 'pub' } }
    let(:socket_class2) { Class.new(socket_class1) { socket_type 'xpub' } }
    let(:socket1) { socket_class1.new }
    let(:socket2) { socket_class2.new }

    it { expect(socket_class1.socket_type).to eq 'pub' }
    it { expect(socket_class2.socket_type).to eq 'xpub' }
    it { expect(socket1.socket_type).to eq :PUB }
    it { expect(socket2.socket_type).to eq :XPUB }
  end

  describe 'build_address' do
    it 'one arg' do
      address = Miu::Socket.build_address 'inproc://mysocket'
      expect(address).to eq 'inproc://mysocket'
    end

    it 'two args' do
      address = Miu::Socket.build_address 'localhost', 12345
      expect(address).to eq 'tcp://localhost:12345'
    end
  end
end

describe Miu::PubSocket do
  it_should_behave_like 'writable socket' do
    let(:socket) { described_class.new }
    let(:type) { :PUB }
  end
end

describe Miu::SubSocket do
  it_should_behave_like 'readable socket' do
    let(:socket) { described_class.new }
    let(:type) { :SUB }
  end
end

describe Miu::ReqSocket do
  it_should_behave_like 'readable/writable socket' do
    let(:socket) { described_class.new }
    let(:type) { :REQ }
  end
end

describe Miu::RepSocket do
  it_should_behave_like 'readable/writable socket' do
    let(:socket) { described_class.new }
    let(:type) { :REP }
  end
end

describe Miu::DealerSocket do
  it_should_behave_like 'readable/writable socket' do
    let(:socket) { described_class.new }
    let(:type) { :DEALER }
  end
end

describe Miu::RouterSocket do
  it_should_behave_like 'readable/writable socket' do
    let(:socket) { described_class.new }
    let(:type) { :ROUTER }
  end
end

describe Miu::PushSocket do
  it_should_behave_like 'writable socket' do
    let(:socket) { described_class.new }
    let(:type) { :PUSH }
  end
end

describe Miu::PullSocket do
  it_should_behave_like 'readable socket' do
    let(:socket) { described_class.new }
    let(:type) { :PULL }
  end
end

describe Miu::XPubSocket do
  it_should_behave_like 'writable socket' do
    let(:socket) { described_class.new }
    let(:type) { :XPUB }
  end
end

describe Miu::XSubSocket do
  it_should_behave_like 'readable socket' do
    let(:socket) { described_class.new }
    let(:type) { :XSUB }
  end
end
