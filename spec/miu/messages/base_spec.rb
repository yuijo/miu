require 'spec_helper'

describe Miu::Messages::Base do
  describe '#initialize' do
    context 'no args' do
      before { @msg = Miu::Messages::Base.new(:type => 'test') }
      subject { @msg }

      its(:id) { should be_instance_of String }
      its(:time) { should be_instance_of Fixnum }
      its(:network) { should be_instance_of Miu::Resources::Network }
      its(:type) { should eq 'test' }
    end

    context 'with args' do
      before do
        @msg = Miu::Messages::Base.new({
          :id => 123,
          :time => 123,
          :network => {:name => 'test'},
          :type => 'type',
          :content => 'content',
        })
      end
      subject { @msg }

      its(:id) { should eq 123 }
      its(:time) { should eq 123 }
      its(:network) { should be_instance_of Miu::Resources::Network }
      its(:type) { should eq 'type' }
      its(:content) { should eq 'content' }
    end
  end

  describe '#to_h' do
    let(:hash) { Miu::Messages::Base.new(:type => 'test').to_h }

    it { expect(hash).to be_instance_of ::Hash }
    it { expect(hash).to have_key :network }
    it { expect(hash).to have_key :type }
    it { expect(hash).to have_key :content }
  end
end
