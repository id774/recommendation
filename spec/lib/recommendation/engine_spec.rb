#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/../../spec_helper'

describe Recommendation, 'Recommendation' do
  context 'Recommendation::Engine' do
    describe 'get_recommendation' do
      it 'should be suggesting interesting products' do
        expected = [[3.3477895267131017, "The Night Listener"], [2.8325499182641614, "Lady in the Water"], [2.530980703765565, "Just My Luck"]]

        supervisor = Recommendation::Supervisor.new(visitors)
        supervisor.train(new_comer)
        engine = Recommendation::Engine.new

        new_comer.keys[0].should be_eql 'Toby'
        engine.get_recommendations(supervisor.table, new_comer.keys[0]).should be_eql expected
      end
    end

    describe 'top_matches' do
      it 'should be finding similar users' do
        expected = [[0.9912407071619299, "Lisa Rose"], [0.9244734516419049, "Mick LaSalle"], [0.8934051474415647, "Claudia Puig"], [0.66284898035987, "Jack Matthews"], [0.38124642583151164, "Gene Seymour"]]

        supervisor = Recommendation::Supervisor.new(visitors)
        supervisor.train(new_comer)
        engine = Recommendation::Engine.new

        new_comer.keys[0].should be_eql 'Toby'
        engine.top_matches(supervisor.table, new_comer.keys[0]).should be_eql expected
      end
    end

    describe 'transform_table' do
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
        expected = [[0.6579516949597695, "You, Me and Dupree"], [0.4879500364742689, "Lady in the Water"], [0.11180339887498941, "Snake on the Plane"], [-0.1798471947990544, "The Night Listener"], [-0.42289003161103106, "Just My Luck"]]

        supervisor = Recommendation::Supervisor.new(visitors)
        supervisor.train(new_comer)
        engine = Recommendation::Engine.new

        movies = supervisor.transform_table

        new_comer.values[0].keys[2].should be_eql 'Superman Returns'
        engine.top_matches(movies, new_comer.values[0].keys[2]).should be_eql expected
      end
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
