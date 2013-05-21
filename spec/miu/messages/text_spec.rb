require 'spec_helper'

describe Miu::Messages::Text do
  it_should_behave_like 'a Miu message', described_class

  it 'is the specialized' do
    msg = described_class.new
    expect(msg.type).to eq 'text'
    expect(msg.content).to be_instance_of Miu::Resources::TextContent
  end
end
