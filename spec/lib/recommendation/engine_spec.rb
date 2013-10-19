#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/../../spec_helper'

describe 'Recommendation::Engine' do
  describe 'recommendation' do
    it 'should be suggesting interesting products' do
      expected = [
        ["The Night Listener", 3.3477895267131017],
        ["Lady in the Water", 2.8325499182641614],
        ["Just My Luck", 2.530980703765565]
      ]

      supervisor = Recommendation::Supervisor.new(visitors)
      supervisor.train(new_comer)
      engine = Recommendation::Engine.new

      new_comer.keys[0].should be_eql 'Toby'
      result = engine.recommendation(supervisor.table, new_comer.keys[0])

      result.length.should be_eql 3
      result[0][0].should be_eql expected[0][0]
      result[0][1].should be_eql expected[0][1]
      result[1][0].should be_eql expected[1][0]
      result[1][1].should be_eql expected[1][1]
      result[2][0].should be_eql expected[2][0]
      result[2][1].should be_eql expected[2][1]
    end
  end

  describe 'top_matches' do
    it 'should be finding similar users' do
      expected = [
        ["Lisa Rose", 0.9912407071619299],
        ["Mick LaSalle", 0.9244734516419049],
        ["Claudia Puig", 0.8934051474415647],
        ["Jack Matthews", 0.66284898035987],
        ["Gene Seymour", 0.38124642583151164]
      ]

      supervisor = Recommendation::Supervisor.new(visitors)
      supervisor.train(new_comer)
      engine = Recommendation::Engine.new

      new_comer.keys[0].should be_eql 'Toby'
      result = engine.top_matches(supervisor.table, new_comer.keys[0])

      result.length.should be_eql 5
      result[0][0].should be_eql expected[0][0]
      result[0][1].should be_eql expected[0][1]
      result[1][0].should be_eql expected[1][0]
      result[1][1].should be_eql expected[1][1]
      result[2][0].should be_eql expected[2][0]
      result[2][1].should be_eql expected[2][1]
      result[3][0].should be_eql expected[3][0]
      result[3][1].should be_eql expected[3][1]
      result[4][0].should be_eql expected[4][0]
      result[4][1].should be_eql expected[4][1]
    end
  end

  describe 'transform_table ' do
    it 'should return reversed critics' do
      supervisor = Recommendation::Supervisor.new(visitors)
      supervisor.train(new_comer)
      engine = Recommendation::Engine.new

      movies = supervisor.transform_table
      movies.should be_eql reversed_critics
    end
  end

  describe 'reversed critics' do
    it 'should be found similar items' do
      expected = [
        ["You, Me and Dupree", 0.6579516949597695],
        ["Lady in the Water", 0.4879500364742689],
        ["Snake on the Plane", 0.11180339887498941],
        ["The Night Listener", -0.1798471947990544],
        ["Just My Luck", -0.42289003161103106]
      ]

      supervisor = Recommendation::Supervisor.new(visitors)
      supervisor.train(new_comer)
      engine = Recommendation::Engine.new

      movies = supervisor.transform_table

      new_comer.values[0].keys[2].should be_eql 'Superman Returns'
      result = engine.top_matches(movies, new_comer.values[0].keys[2])

      result.length.should be_eql 5
      result[0][0].should be_eql expected[0][0]
      result[0][1].should be_eql expected[0][1]
      result[1][0].should be_eql expected[1][0]
      result[1][1].should be_eql expected[1][1]
      result[2][0].should be_eql expected[2][0]
      result[2][1].should be_eql expected[2][1]
      result[3][0].should be_eql expected[3][0]
      result[3][1].should be_eql expected[3][1]
      result[4][0].should be_eql expected[4][0]
      result[4][1].should be_eql expected[4][1]
    end
  end

  describe 'recommendation for the unexisting user' do
    it 'should return empty array' do
      expected = []

      supervisor = Recommendation::Supervisor.new(visitors)
      supervisor.train(new_comer)
      engine = Recommendation::Engine.new

      result = engine.recommendation(supervisor.table, 'hoge')
      result.length.should be_eql 0
    end
  end

  describe 'top_matches for the unexisting item' do
    it 'should return all zero score' do
      expected = [
        ["Toby", 0],
        ["Mick LaSalle", 0],
        ["Michael Phillips", 0],
        ["Lisa Rose", 0],
        ["Jack Matthews", 0]
      ]

      supervisor = Recommendation::Supervisor.new(visitors)
      supervisor.train(new_comer)
      engine = Recommendation::Engine.new

      result = engine.top_matches(supervisor.table, 'fuga')

      result.length.should be_eql 5
      result[0][0].should be_eql expected[0][0]
      result[0][1].should be_eql expected[0][1]
      result[1][0].should be_eql expected[1][0]
      result[1][1].should be_eql expected[1][1]
      result[2][0].should be_eql expected[2][0]
      result[2][1].should be_eql expected[2][1]
      result[3][0].should be_eql expected[3][0]
      result[3][1].should be_eql expected[3][1]
      result[4][0].should be_eql expected[4][0]
      result[4][1].should be_eql expected[4][1]
    end
  end
end

def new_comer
  {
    'Toby' => {
      'Snake on the Plane' => 4.5,
      'You, Me and Dupree' => 1.0,
      'Superman Returns'   => 4.0
    }
  }
end

def visitors
  {
    'Lisa Rose' => {
      'Lady in the Water'  => 2.5,
      'Snake on the Plane' => 3.5,
      'Just My Luck'       => 3.0,
      'Superman Returns'   => 3.5,
      'You, Me and Dupree' => 2.5,
      'The Night Listener' => 3.0
    },

    'Gene Seymour' => {
      'Lady in the Water'  => 3.0,
      'Snake on the Plane' => 3.5,
      'Just My Luck'       => 1.5,
      'Superman Returns'   => 5.0,
      'The Night Listener' => 3.0,
      'You, Me and Dupree' => 3.5
    },

    'Michael Phillips' => {
      'Lady in the Water'  => 2.5,
      'Snake on the Plane' => 3.0,
      'Superman Returns'   => 3.5,
      'The Night Listener' => 4.0
    },

    'Claudia Puig' => {
      'Snake on the Plane' => 3.5,
      'Just My Luck'       => 3.0,
      'The Night Listener' => 4.5,
      'Superman Returns'   => 4.0,
      'You, Me and Dupree' => 2.5
    },

    'Mick LaSalle' => {
      'Lady in the Water'  => 3.0,
      'Snake on the Plane' => 4.0,
      'Just My Luck'       => 2.0,
      'Superman Returns'   => 3.0,
      'The Night Listener' => 3.0,
      'You, Me and Dupree' => 2.0
    },

    'Jack Matthews' => {
      'Lady in the Water'  => 3.0,
      'Snake on the Plane' => 4.0,
      'The Night Listener' => 3.0,
      'Superman Returns'   => 5.0,
      'You, Me and Dupree' => 3.5
    }
  }
end

def reversed_critics
  {
    "Lady in the Water" => {
      "Lisa Rose"        => 2.5,
      "Gene Seymour"     => 3.0,
      "Michael Phillips" => 2.5,
      "Mick LaSalle"     => 3.0,
      "Jack Matthews"    => 3.0
    },

    "Snake on the Plane" => {
      "Lisa Rose"        => 3.5,
      "Gene Seymour"     => 3.5,
      "Michael Phillips" => 3.0,
      "Claudia Puig"     => 3.5,
      "Mick LaSalle"     => 4.0,
      "Jack Matthews"    => 4.0,
      "Toby"             => 4.5
    },

    "Just My Luck" => {
      "Lisa Rose"        => 3.0,
      "Gene Seymour"     => 1.5,
      "Claudia Puig"     => 3.0,
      "Mick LaSalle"     => 2.0
    },

    "Superman Returns" => {
      "Lisa Rose"        => 3.5,
      "Gene Seymour"     => 5.0,
      "Michael Phillips" => 3.5,
      "Claudia Puig"     => 4.0,
      "Mick LaSalle"     => 3.0,
      "Jack Matthews"    => 5.0,
      "Toby"             => 4.0
    },

    "You, Me and Dupree" => {
      "Lisa Rose"        => 2.5,
      "Gene Seymour"     => 3.5,
      "Claudia Puig"     => 2.5,
      "Mick LaSalle"     => 2.0,
      "Jack Matthews"    => 3.5,
      "Toby"             => 1.0
    },

    "The Night Listener" => {
      "Lisa Rose"        => 3.0,
      "Gene Seymour"     => 3.0,
      "Michael Phillips" => 4.0,
      "Claudia Puig"     => 4.5,
      "Mick LaSalle"     => 3.0,
      "Jack Matthews"    => 3.0
    }
  }
end
