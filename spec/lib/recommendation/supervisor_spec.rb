#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/../../spec_helper'

describe 'Recommendation::Supervisor' do
  context '#initialize and #table' do
    subject {
      supervisor = Recommendation::Supervisor.new
      supervisor.table
    }

    let(:expected) { {} }

    it 'should have empty hash' do
      expect(subject).to eq expected
    end
  end

  context '#initialize with args and #table' do
    subject {
      supervisor = Recommendation::Supervisor.new(initial_data)
      supervisor.table
    }

    let(:expected) { initial_data }

    it 'should have hash of args' do
      expect(subject).to eq expected
    end
  end

  context '#initialize with args and #train with append data' do
    subject {
      supervisor = Recommendation::Supervisor.new(initial_data)
      supervisor.train(append_data)
      supervisor.table
    }

    let(:expected) { merged_data }

    it 'should have merged data' do
      expect(subject).to eq expected
    end
  end

  context '#initialize with merged data and #recommendation' do
    subject {
      supervisor = Recommendation::Supervisor.new(merged_data)
      engine = Recommendation::Engine.new
      engine.recommendation(supervisor.table, 'user_4')
    }

    let(:expected) { [["item_6", 220.0]] }

    it 'should be suggested successful' do
      expect(subject).to eq expected
    end
  end

  context '#initialize with merged data and #top_matches' do
    subject {
      supervisor = Recommendation::Supervisor.new(merged_data)
      engine = Recommendation::Engine.new
      engine.top_matches(supervisor.table, 'user_4')
    }

    let(:expected) { [["user_2", 1.0], ["user_1", 1.0], ["user_3", 0]] }

    it 'should be suggested successful' do
      expect(subject).to eq expected
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
