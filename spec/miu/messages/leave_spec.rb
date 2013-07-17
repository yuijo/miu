require 'spec_helper'

describe Miu::Messages::Leave do
  it_should_behave_like 'a Miu message', described_class

  it 'is a Leave message' do
    msg = described_class.new
    expect(msg.type).to eq 'leave'
    expect(msg).to be_respond_to :room
    expect(msg).to be_respond_to :user
    expect(msg.room).to be_instance_of Miu::Resources::Room
    expect(msg.user).to be_instance_of Miu::Resources::User
  end
end
