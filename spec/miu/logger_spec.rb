require 'spec_helper'

describe Miu::Logger do
  before { Miu.logger = Miu.default_logger }

  it { expect(Miu.logger).to be_instance_of ::Logger }
  it { expect(Miu.logger.level).to eq ::Logger::INFO }

  let(:msg) { 'test message' }

  LEVELS = %w(debug info warn error fatal)

  LEVELS.each do  |level|
    it "call #{level} when logger is default" do
      Miu.logger.should_receive(level).with(msg).once
      Miu::Logger.__send__(level, msg)
    end
  end

  LEVELS.each do  |level|
    it "call #{level} when logger is nil" do
      allow_message_expectations_on_nil
      Miu.logger = nil
      Miu.logger.should_not_receive(level)
      Miu::Logger.__send__(level, msg)
    end
  end

  context 'include' do
    class MyObject
      include Miu::Logger
    end

    let(:obj) { MyObject.new }
    LEVELS.each do |level|
      it { expect(obj).to be_respond_to(level, true) }
    end
  end
end
