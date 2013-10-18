# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/../spec_helper'

describe Recommendation do
  context 'const get :VERSION should' do
    it "return right version number" do
      expect = '0.1.3'
      Recommendation.const_get(:VERSION).should be_true
      Recommendation.const_get(:VERSION).should == expect
    end
  end
end
