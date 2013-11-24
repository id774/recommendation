#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/../../spec_helper'

describe 'Recommendation::Engine' do
  context '#recommendation' do

    subject {
      supervisor = Recommendation::Supervisor.new(visitors)
      supervisor.train(new_comer)
      engine = Recommendation::Engine.new
      engine.recommendation(supervisor.table, new_comer.keys[0])
    }

    let(:expected) {
      [
        ["The Night Listener", 3.3477895267131017],
        ["Lady in the Water", 2.8325499182641614],
        ["Just My Luck", 2.530980703765565]
      ]
    }

    it 'should be suggesting interesting products' do
      expect(subject).to eq expected
    end
  end

  context '#top_matches' do

    subject {
      supervisor = Recommendation::Supervisor.new(visitors)
      supervisor.train(new_comer)
      engine = Recommendation::Engine.new
      engine.top_matches(supervisor.table, new_comer.keys[0])
    }

    let(:expected) {
      [
        ["Lisa Rose", 0.9912407071619299],
        ["Mick LaSalle", 0.9244734516419049],
        ["Claudia Puig", 0.8934051474415647],
        ["Jack Matthews", 0.66284898035987],
        ["Gene Seymour", 0.38124642583151164]
      ]
    }

    it 'should be finding similar users' do
      expect(subject).to eq expected
    end
  end

  context 'reversed critics' do

    subject {
      supervisor = Recommendation::Supervisor.new(visitors)
      supervisor.train(new_comer)
      engine = Recommendation::Engine.new
      movies = supervisor.transform_table
      engine.top_matches(movies, new_comer.values[0].keys[2])
    }

    let(:expected) {
      [
        ["You, Me and Dupree", 0.6579516949597695],
        ["Lady in the Water", 0.4879500364742689],
        ["Snake on the Plane", 0.11180339887498941],
        ["The Night Listener", -0.1798471947990544],
        ["Just My Luck", -0.42289003161103106]
      ]
    }

    it 'should be found similar items' do
      expect(subject).to eq expected
    end
  end

  context 'recommendation for the unexisting user' do

    subject {
      supervisor = Recommendation::Supervisor.new(visitors)
      supervisor.train(new_comer)
      engine = Recommendation::Engine.new
      engine.recommendation(supervisor.table, 'hoge')
    }

    let(:expected) { [] }

    it 'should return empty array' do
      expect(subject).to eq expected
    end
  end

  context 'top_matches for the unexisting item' do
    subject {
      supervisor = Recommendation::Supervisor.new(visitors)
      supervisor.train(new_comer)
      engine = Recommendation::Engine.new
      engine.top_matches(supervisor.table, 'fuga')
    }

    let(:expected) {
      [
        ["Toby", 0],
        ["Mick LaSalle", 0],
        ["Michael Phillips", 0],
        ["Lisa Rose", 0],
        ["Jack Matthews", 0]
      ]
    }

    it 'should return all zero' do
      expect(subject).to eq expected
    end
  end
end

describe 'Recommendation::Supervisor' do
  context '#transform_table ' do
    subject {
      supervisor = Recommendation::Supervisor.new(visitors)
      supervisor.train(new_comer)
      engine = Recommendation::Engine.new
      supervisor.transform_table
    }

    it 'should return reversed critics' do
      expect(subject).to eq reversed_critics
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
