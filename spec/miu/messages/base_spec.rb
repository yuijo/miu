require 'spec_helper'

describe Miu::Messages::Base do
  describe '#initialize' do
    context 'no args' do
      before { @msg = Miu::Messages::Base.new(:type => 'test') }
      subject { @msg }

      its(:id) { should be_instance_of String }
      its(:time) { should be_instance_of Fixnum }
      its(:network) { should be_instance_of Miu::Resources::Network }
      its(:type) { should be_instance_of Miu::Type }
      its(:content_type) { should eq 'test' }
      its(:sub_type) { should be_empty }
    end

    context 'with args' do
      before do
        @msg = Miu::Messages::Base.new({
          :id => 123,
          :time => 123,
          :network => {:name => 'test'},
          :type => 'type',
          :sub_type => 'sub_type',
          :content => 'content',
        })
      end
      subject { @msg }

      its(:id) { should eq 123 }
      its(:time) { should eq 123 }
      its(:network) { should be_instance_of Miu::Resources::Network }
      its(:type) { should eq 'type.sub_type' }
      its(:content_type) { should eq 'type' }
      its(:sub_type) { should eq 'sub_type' }
      its(:content) { should eq 'content' }
    end
  end
end
