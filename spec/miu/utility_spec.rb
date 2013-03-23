require 'spec_helper'

describe Miu::Utility do
  describe 'adapt' do
    X = Struct.new(:value)

    it 'adapted' do
      x = X.new(123)
      X.should_not_receive(:new)
      Miu::Utility.adapt(X, x)
    end

    it 'unadapted' do
      X.should_receive(:new).with(123)
      Miu::Utility.adapt(X, 123)
    end
  end

  describe 'extract_options!' do
    it 'with options' do
      args = [1, 2, 3, {:a => :b}]
      options = Miu::Utility.extract_options! args

      args.should == [1, 2, 3]
      options.should == {:a => :b}
    end

    it 'without options' do
      args = [1, 2, 3]
      options = Miu::Utility.extract_options! args

      args.should == [1, 2, 3]
      options.should == {}
    end
  end

  describe 'symbolize_keys' do
    it 'symbolize' do
      h1 = {'a' => 'b', :c => :d, 1 => 2}
      h2 = Miu::Utility.symbolize_keys h1
      h2.should == {:a => 'b', :c => :d, 1 => 2}
    end
  end

  describe 'underscorize_keys' do
    it 'underscorize' do
      h1 = {'a-b' => 1, 'a-b_c-d' => 2, :abc => 3}
      h2 = Miu::Utility.underscorize_keys h1
      h2.should == {'a_b' => 1, 'a_b_c_d' => 2, :abc => 3}
    end
  end

  describe 'optionify_keys' do
    it 'optionify' do
      h1 = {'a-b' => 1, 'a-b_c-d' => 2, :'a-b_c-d_e' => 3}
      h2 = Miu::Utility.optionify_keys h1
      h2.should == {:a_b => 1, :a_b_c_d => 2, :a_b_c_d_e => 3}
    end
  end
end
