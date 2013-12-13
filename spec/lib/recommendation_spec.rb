# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/../spec_helper'

describe Recommendation do
  context "VERSION" do
    subject { Recommendation::VERSION }

    it { expect(subject).to eq "0.3.0" }
  end
end
