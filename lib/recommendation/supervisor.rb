#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

module Recommendation
  class Supervisor
    attr_accessor :table

    def initialize(params = {})
      @table = params
    end

    def train(params = {})
      @table.merge!(params)
    end

    def transform_table
      new_table = {}
      @table.each do |key, value|
        value.each do |new_key, new_value|
          new_table[new_key] ||= Hash.new
          new_table[new_key][key] = new_value
        end
      end
      new_table
    end
  end
end
