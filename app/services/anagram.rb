# encoding: utf-8
require 'storage_adapters/init'

module Kata
  module Service
    #Business service for handeling Anagram generation
    class Anagram
      def get_anagrams query
        result = {}
        split(query) do |word|
          a = anagrams(word)
          result[word] = a unless a.empty?
        end
        result
      end

      def add_dictionary_file file_contents
        split(file_contents) do |word|
          save_word normalize(word)
        end
      end

      def empty_dictionary
        StorageAdapter::Dictionary.new.flush_db
      end

      private

      def split phrase
        phrase.scan(/[\w']+/) { |w| yield w }
      end

      def anagrams word
        a = StorageAdapter::Dictionary.new.get_anagrams sort_chars(word)
        a.delete_if { |w| w == word }
      end

      def save_word word
        StorageAdapter::Dictionary.new.add_word sort_chars(word), word
      end

      def sort_chars word
        word.chars.sort.join
      end

      def normalize text
        text.downcase.scan(/[a-z]/).join
      end
    end
  end
end
