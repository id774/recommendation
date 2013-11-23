# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/../spec_helper'

describe Recommendation do
  context "VERSION" do
    subject { Recommendation::VERSION }

    it { expect(subject).to eql "0.2.0" }
  end
end
