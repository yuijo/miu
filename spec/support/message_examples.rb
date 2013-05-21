shared_examples 'a Miu message' do |message_class|
  describe '#initialize' do
    context 'no args' do
      let(:msg) do
        message_class.new
      end

      include_examples 'a Miu message have valid attributes'
    end

    context 'with args' do
      let(:msg) do
        message_class.new({
          :id => 'aaa',
          :time => 123,
          :network => {:name => 'bbb'},
          :type => 'ccc',
        })
      end

      include_examples 'a Miu message have valid attributes'

      it 'assign args to attributes' do
        expect(msg.id).to eq 'aaa'
        expect(msg.time).to eq 123
        expect(msg.network.name).to eq 'bbb'
        expect(msg.type).to eq 'ccc'
      end
    end
  end

  describe '#to_h' do
    let(:msg) { message_class.new }
    let(:hash) { msg.to_h }

    it 'outputs valid attributes' do
      expect(hash).to be_instance_of ::Hash
      expect(hash).to have_key :id
      expect(hash).to have_key :time
      expect(hash).to have_key :network
      expect(hash).to have_key :type
      expect(hash).to have_key :content
    end
  end
end

shared_examples 'a Miu message have valid attributes' do
  it 'have valid attributes' do
    expect(msg.id).to be_instance_of String
    expect(msg.time).to be_instance_of Fixnum
    expect(msg.network).to be_instance_of Miu::Resources::Network
    expect(msg).to be_respond_to :type
    expect(msg).to be_respond_to :content
  end
end
