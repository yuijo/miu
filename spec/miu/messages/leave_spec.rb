require 'spec_helper'

describe Miu::Messages::Leave do
  describe '#initialize' do
    context 'no args' do
      before do
        @msg = Miu::Messages::Leave.new
      end
      subject { @msg }

      its(:id) { should be_instance_of String }
      its(:time) { should be_instance_of Fixnum }
      its(:network) { should be_instance_of Miu::Resources::Network }
      its(:type) { should eq 'leave' }
    end

    context 'with args' do
      before do
        @msg = Miu::Messages::Leave.new({
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
      its(:type) { should eq 'leave' }
      its(:content) { should be_instance_of Miu::Resources::LeaveContent }
    end
  end
end
