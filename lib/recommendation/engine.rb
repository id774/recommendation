#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

module Recommendation
  class Engine
    def recommendations(table, id, similarity=:sim_pearson)
      totals_h = Hash.new(0)
      sim_sums_h = Hash.new(0)
      table.each do |other, val|
        next if other == id
        sim = __send__(similarity, table, id, other)
        next if sim <= 0
        table[other].each do |item, val|
          if !table[id].keys.include?(item) || table[id][item] == 0
            totals_h[item] += table[other][item]*sim
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

    def top_matches(table, id, n=5, similarity=:sim_pearson)
      scores = Array.new
      table.each do |key, value|
        if key != id
          scores << [__send__(similarity, table, id,key), key]
        end
      end
      scores.sort.reverse[0,n]
    end

    private

    def sim_pearson(table, id1, id2)
      shared_items_a = shared_items_a(table, id1, id2)

      n = shared_items_a.size
      return 0 if n == 0

      sum1 = shared_items_a.inject(0) {|result, si|
        result + table[id1][si]
      }
      sum2 = shared_items_a.inject(0) {|result, si|
        result + table[id2][si]
      }

      sum1_sq = shared_items_a.inject(0) {|result, si|
        result + table[id1][si]**2
      }
      sum2_sq = shared_items_a.inject(0) {|result, si|
        result + table[id2][si]**2
      }

      sum_products = shared_items_a.inject(0) {|result, si|
        result + table[id1][si]*table[id2][si]
      }

      num = sum_products - (sum1*sum2/n)
      den = Math.sqrt((sum1_sq - sum1**2/n)*(sum2_sq - sum2**2/n))
      return 0 if den == 0
      return num/den
    end

    def shared_items(table, id1, id2)
      shared_items_h = Hash.new
      table[id1].each do |k, v|
        shared_items_h[k] = 1 if table[id2].include?(k)
      end
      shared_items_h
    end

    def shared_items_a(table, id1, id2)
      table[id1].keys & table[id2].keys
    end
  end
end
