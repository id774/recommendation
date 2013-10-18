#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

$:.unshift File.join(File.dirname(__FILE__))

require 'lib/recommendation'

def demo
  supervisor = Recommendation::Supervisor.new(visitors)
  supervisor.train(new_comer)
  engine = Recommendation::Engine.new

  p engine.get_recommendations(supervisor.table, 'Toby') #=> [[3.3477895267131017, "The Night Listener"], [2.8325499182641614, "Lady in the Water"], [2.530980703765565, "Just My Luck"]]

  p engine.top_matches(supervisor.table, 'Toby') #=> [[0.9912407071619299, "Lisa Rose"], [0.9244734516419049, "Mick LaSalle"], [0.8934051474415647, "Claudia Puig"], [0.66284898035987, "Jack Matthews"], [0.38124642583151164, "Gene Seymour"]]

  movies = supervisor.transform_table
  p engine.top_matches(movies, 'Superman Returns') #=> [[0.6579516949597695, "You, Me and Dupree"], [0.4879500364742689, "Lady in the Water"], [0.11180339887498941, "Snake on the Plane"], [-0.1798471947990544, "The Night Listener"], [-0.42289003161103106, "Just My Luck"]]

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

demo
