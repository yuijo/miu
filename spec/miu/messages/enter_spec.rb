require 'spec_helper'

describe Miu::Messages::Enter do
  describe '#initialize' do
    context 'no args' do
      before do
        @msg = Miu::Messages::Enter.new
      end
      subject { @msg }

      its(:id) { should be_instance_of String }
      its(:time) { should be_instance_of Fixnum }
      its(:network) { should be_instance_of Miu::Resources::Network }
      its(:type) { should eq 'enter' }
    end

    context 'with args' do
      before do
        @msg = Miu::Messages::Enter.new({
          :id => 123,
          :time => 123,
          :network => {:name => 'test'},
          :content => {},
        })
      end
      subject { @msg }

      its(:id) { should eq 123 }
      its(:time) { should eq 123 }
      its(:network) { should be_instance_of Miu::Resources::Network }
      its(:type) { should eq 'enter' }
      its(:content) { should be_instance_of Miu::Resources::EnterContent }
    end
  end
end
