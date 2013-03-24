require 'spec_helper'

describe Miu::Type do
  describe '#initialize' do
    context 'no args' do
      before { @type = Miu::Type.new }
      subject { @type }

      its(:content_type) { should be_empty }
      its(:sub_type) { should be_empty }
      its(:sub_type?) { should be_false }
    end

    context 'with 1 arg' do
      before { @type = Miu::Type.new 'foo' }
      subject { @type }

      its(:content_type) { should eq 'foo' }
      its(:sub_type) { should be_empty }
      its(:sub_type?) { should be_false }
    end

    context 'with 2 args' do
      before { @type = Miu::Type.new 'foo', 'bar' }
      subject { @type }

      its(:content_type) { should eq 'foo' }
      its(:sub_type) { should eq 'bar' }
      its(:sub_type?) { should be_true }
    end

    context 'with 3 args' do
      before { @type = Miu::Type.new 'foo', 'bar', 'buzz' }
      subject { @type }

      its(:content_type) { should eq 'foo' }
      its(:sub_type) { should eq 'bar.buzz' }
      its(:sub_type?) { should be_true }
    end
  end

  describe '#to_s' do
    let(:str) { Miu::Type.new('foo', 'bar', 'buzz').to_s }

    it { expect(str).to be_instance_of String }
    it { expect(str).to eq 'foo.bar.buzz' }
  end

  describe '#to_msgpack' do
    let(:data) { Miu::Type.new('foo', 'bar', 'buzz').to_msgpack }

    it { expect(data).to be_instance_of String }
    it { expect(data).to eq 'foo.bar.buzz'.to_msgpack }
  end
end
