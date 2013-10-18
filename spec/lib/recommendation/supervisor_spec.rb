#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/../../spec_helper'

describe 'Recommendation::Supervisor' do
  describe 'initialize and table' do
    it 'should have empty hash' do
      supervisor = Recommendation::Supervisor.new
      supervisor.table.length.should be_eql 0
    end
  end

  describe 'initialize and table with args' do
    it 'should have hash of args' do
      supervisor = Recommendation::Supervisor.new(initial_data)
      supervisor.table.should be_eql initial_data
    end
  end

  describe 'train' do
    it 'should merge additional data' do
      supervisor = Recommendation::Supervisor.new(initial_data)
      supervisor.train(append_data)
      supervisor.table.should be_eql merged_data
    end
  end

  describe 'integration with engine' do
    it 'should be suggesting successful' do
      supervisor = Recommendation::Supervisor.new(merged_data)
      engine = Recommendation::Engine.new

      expected = {"item_6" => 220.0}
      result = engine.recommendation(supervisor.table, 'user_4')
      result.should be_eql expected

      expected = {"user_2"=>1.0, "user_1"=>1.0, "user_3"=>0}
      result = engine.top_matches(supervisor.table, 'user_4')
      result.should be_eql expected
    end
  end
end

def initial_data
  {
    "user_1" => {
      "item_1" => 100,
      "item_2" => 140,
      "item_3" => 160
    },
    "user_2" => {
      "item_2" => 200,
      "item_4" => 210,
      "item_6" => 220
    },
    "user_3" => {
      "item_3" => 300,
      "item_6" => 330,
      "item_9" => 360
    }
  }
end

def append_data
  {
    "user_1" => {
      "item_2" => 400,
      "item_7" => 410,
    },
    "user_4" => {
      "item_2" => 150,
      "item_4" => 230,
      "item_7" => 580
    }
  }
end

def merged_data
  {
    "user_1" => {
      "item_2" => 400,
      "item_7" => 410
    },
    "user_2" => {
      "item_2" => 200,
      "item_4" => 210,
      "item_6" => 220
    },
    "user_3" => {
      "item_3" => 300,
      "item_6" => 330,
      "item_9" => 360
    },
    "user_4" => {
      "item_2" => 150,
      "item_4" => 230,
      "item_7" => 580
    }
  }
end
