require 'spec_helper'

describe Miu::Messages::Text do
  describe '#initialize' do
    context 'no args' do
      before do
        @msg = Miu::Messages::Text.new
      end
      subject { @msg }

      its(:id) { should be_instance_of String }
      its(:time) { should be_instance_of Fixnum }
      its(:network) { should be_instance_of Miu::Resources::Network }
      its(:type) { should eq 'text' }
      its(:content_type) { should eq 'text' }
      its(:sub_type) { should be_empty }
    end

    context 'with args' do
      before do
        @msg = Miu::Messages::Text.new({
          :id => 123,
          :time => 123,
          :network => {:name => 'test'},
          :sub_type => 'notice',
          :content => {},
        })
      end
      subject { @msg }

      its(:id) { should eq 123 }
      its(:time) { should eq 123 }
      its(:network) { should be_instance_of Miu::Resources::Network }
      its(:type) { should eq 'text.notice' }
      its(:content_type) { should eq 'text' }
      its(:sub_type) { should eq 'notice' }
      its(:content) { should be_instance_of Miu::Resources::TextContent }
    end
  end
end
