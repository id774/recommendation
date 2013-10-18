#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

module Recommendation
  class Engine
    def initialize(params = {})
      @prefs = params
    end

    def train(params = {})
      @prefs.merge!(params)
    end

    def prefs
      @prefs
    end

    def transform_prefs
      result = {}
      @prefs.each do |key, value|
        value.each do |new_key, new_value|
          result[new_key] ||= Hash.new
          result[new_key][key] = new_value
        end
      end
      result
    end

    def get_recommendations(prefs, person, similarity=:sim_pearson)
      totals_h = Hash.new(0)
      sim_sums_h = Hash.new(0)
      prefs.each do |other, val|
        next if other == person
        sim = __send__(similarity, prefs, person, other)
        next if sim <= 0
        prefs[other].each do |item, val|
          if !prefs[person].keys.include?(item) || prefs[person][item] == 0
            totals_h[item] += prefs[other][item]*sim
            sim_sums_h[item] += sim
          end
        end
      end

      rankings = Array.new
      totals_h.each do |item, total|
        rankings << [total/sim_sums_h[item], item]
      end
      rankings.sort.reverse
    end

    def top_matches(prefs, person, n=5, similarity=:sim_pearson)
      scores = Array.new
      prefs.each do |key, value|
        if key != person
          scores << [__send__(similarity, prefs, person,key), key]
        end
      end
      scores.sort.reverse[0,n]
    end

    private

    def sim_pearson(prefs, person1, person2)
      shared_items_a = shared_items_a(prefs, person1, person2)

      n = shared_items_a.size
      return 0 if n == 0

      sum1 = shared_items_a.inject(0) {|result, si|
        result + prefs[person1][si]
      }
      sum2 = shared_items_a.inject(0) {|result, si|
        result + prefs[person2][si]
      }

      sum1_sq = shared_items_a.inject(0) {|result, si|
        result + prefs[person1][si]**2
      }
      sum2_sq = shared_items_a.inject(0) {|result, si|
        result + prefs[person2][si]**2
      }

      sum_products = shared_items_a.inject(0) {|result, si|
        result + prefs[person1][si]*prefs[person2][si]
      }

      num = sum_products - (sum1*sum2/n)
      den = Math.sqrt((sum1_sq - sum1**2/n)*(sum2_sq - sum2**2/n))
      return 0 if den == 0
      return num/den
    end

    def shared_items(prefs, person1, person2)
      shared_items_h = Hash.new
      prefs[person1].each do |k, v|
        shared_items_h[k] = 1 if prefs[person2].include?(k)
      end
      shared_items_h
    end

    def shared_items_a(prefs, person1, person2)
      prefs[person1].keys & prefs[person2].keys
    end
  end
end
