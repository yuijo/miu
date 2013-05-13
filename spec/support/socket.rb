shared_examples 'readable socket' do
  it { expect(socket.socket_type).to eq type }
  it { expect(socket).to be_kind_of Miu::Socket }
  it { expect(socket).to be_kind_of Miu::ReadableSocket }
  it { expect(socket).to_not be_kind_of Miu::WritableSocket }
end

shared_examples 'writable socket' do
  it { expect(socket.socket_type).to eq type }
  it { expect(socket).to be_kind_of Miu::Socket }
  it { expect(socket).to_not be_kind_of Miu::ReadableSocket }
  it { expect(socket).to be_kind_of Miu::WritableSocket }
end

shared_examples 'readable/writable socket' do
  it { expect(socket.socket_type).to eq type }
  it { expect(socket).to be_kind_of Miu::Socket }
  it { expect(socket).to be_kind_of Miu::ReadableSocket }
  it { expect(socket).to be_kind_of Miu::WritableSocket }
end

shared_examples 'publishable socket' do
  let(:pub) { Miu::Publisher.new(:socket => base) }
  it { expect(pub).to be_kind_of(base) }
  it { expect(pub).to be_kind_of(Miu::Writable) }
  it { expect(pub).to be_respond_to(:connect, :write) }
end

shared_examples 'subscribable socket' do
  let(:sub) { Miu::Subscriber.new(:socket => base) }
  it { expect(sub).to be_kind_of(base) }
  it { expect(sub).to be_kind_of(Miu::Readable) }
  it { expect(sub).to be_respond_to(:connect, :read) }
end
