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
      supervisor = Recommendation::Supervisor.new(
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
      )

      supervisor.table.length.should be_eql 3
      supervisor.table["user_1"]["item_1"].should be_eql 100
      supervisor.table["user_1"]["item_2"].should be_eql 140
      supervisor.table["user_1"]["item_3"].should be_eql 160
      supervisor.table["user_2"]["item_2"].should be_eql 200
      supervisor.table["user_2"]["item_4"].should be_eql 210
      supervisor.table["user_2"]["item_6"].should be_eql 220
      supervisor.table["user_3"]["item_3"].should be_eql 300
      supervisor.table["user_3"]["item_6"].should be_eql 330
      supervisor.table["user_3"]["item_9"].should be_eql 360
    end
  end

  describe 'train' do
    it 'should merge additional data' do
      supervisor = Recommendation::Supervisor.new(
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
      )

      supervisor.train(
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
      )

      supervisor.table.length.should be_eql 4
      supervisor.table["user_1"]["item_1"].should be_nil
      supervisor.table["user_1"]["item_2"].should be_eql 400
      supervisor.table["user_1"]["item_3"].should be_nil
      supervisor.table["user_1"]["item_7"].should be_eql 410
      supervisor.table["user_2"]["item_2"].should be_eql 200
      supervisor.table["user_2"]["item_4"].should be_eql 210
      supervisor.table["user_2"]["item_6"].should be_eql 220
      supervisor.table["user_3"]["item_3"].should be_eql 300
      supervisor.table["user_3"]["item_6"].should be_eql 330
      supervisor.table["user_3"]["item_9"].should be_eql 360
      supervisor.table["user_4"]["item_2"].should be_eql 150
      supervisor.table["user_4"]["item_4"].should be_eql 230
      supervisor.table["user_4"]["item_7"].should be_eql 580
    end
  end

  describe 'integration with engine' do
    it 'should be suggesting successful' do
      supervisor = Recommendation::Supervisor.new(
        {
          "user_1" => {
            "item_2" => 400,
            "item_7" => 410,
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
      )
      engine = Recommendation::Engine.new

      expected = [[220.0, "item_6"]]
      result = engine.recommendation(supervisor.table, 'user_4')

      result.length.should be_eql 1
      result[0].length.should be_eql 2
      result[0][0].should be_eql expected[0][0]
      result[0][1].should be_eql expected[0][1]

      expected = [[1.0, "user_2"], [1.0, "user_1"], [0, "user_3"]]
      result = engine.top_matches(supervisor.table, 'user_4')

      result.length.should be_eql 3
      result[0].length.should be_eql 2
      result[0][0].should be_eql expected[0][0]
      result[0][1].should be_eql expected[0][1]
      result[1][0].should be_eql expected[1][0]
      result[1][1].should be_eql expected[1][1]
      result[2][0].should be_eql expected[2][0]
      result[2][1].should be_eql expected[2][1]
    end
  end
end
