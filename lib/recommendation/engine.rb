#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

module Recommendation
  class Engine
    def recommendation(table, user, similarity=:sim_pearson)
      totals_h = Hash.new(0)
      sim_sums_h = Hash.new(0)
      table.each do |other, val|
        next if other == user
        sim = __send__(similarity, table, user, other)
        next if sim <= 0
        table[other].each do |item, val|
          if !table[user].keys.include?(item) || table[user][item] == 0
            totals_h[item] += table[other][item]*sim
            sim_sums_h[item] += sim
          end
        end
      end

      rankings = Hash.new
      totals_h.each do |item, total|
        rankings[item] = total/sim_sums_h[item]
      end

      rankings.sort_by{|k, v| -v}
    end

    def top_matches(table, user, n=5, similarity=:sim_pearson)
      scores = Array.new
      table.each do |key, value|
        if key != user
          scores << [__send__(similarity, table, user,key), key]
        end
      end

      result = Array.new
      scores.sort.reverse[0,n].each do |k, v|
        result << [v, k]
      end
      result
    end

    private

    def sim_pearson(table, user1, user2)
      shared_items_a = shared_items_a(table, user1, user2)

      n = shared_items_a.size
      return 0 if n == 0

      sum1 = shared_items_a.inject(0) {|result, si|
        result + table[user1][si]
      }
      sum2 = shared_items_a.inject(0) {|result, si|
        result + table[user2][si]
      }

      sum1_sq = shared_items_a.inject(0) {|result, si|
        result + table[user1][si]**2
      }
      sum2_sq = shared_items_a.inject(0) {|result, si|
        result + table[user2][si]**2
      }

      sum_products = shared_items_a.inject(0) {|result, si|
        result + table[user1][si]*table[user2][si]
      }

      num = sum_products - (sum1*sum2/n)
      den = Math.sqrt((sum1_sq - sum1**2/n)*(sum2_sq - sum2**2/n))
      return 0 if den == 0
      return num/den
    end

    def shared_items(table, user1, user2)
      shared_items_h = Hash.new
      table[user1].each do |k, v|
        shared_items_h[k] = 1 if table[user2].include?(k)
      end
      shared_items_h
    end

    def shared_items_a(table, user1, user2)
      table[user1].nil? ? [] : table[user1].keys & table[user2].keys
    end
  end
end
