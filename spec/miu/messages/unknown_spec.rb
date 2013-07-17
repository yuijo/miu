require 'spec_helper'

describe Miu::Messages::Unknown do
  it_should_behave_like 'a Miu message', described_class

  it 'is a Unknown message' do
    msg = described_class.new
    expect(msg.type).to eq 'unknown'
    expect(msg).to be_respond_to :value
  end
end
