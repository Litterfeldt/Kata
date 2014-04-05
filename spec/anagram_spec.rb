# encoding: utf-8
require 'services/anagram'
require 'spec_helper'

describe 'Anagram engine' do
  subject { Kata::Service::Anagram.new }

    context 'no data in database' do
      it "doesn't return any anagrams" do
        subject.get_anagrams('query').should be_empty
      end
    end

    context 'data in database' do
      let (:wierd_input) { "tac cat\r\nact\ntoc cot\roct" }
      it 'handles weird input' do
        subject.add_dictionary_file(wierd_input).should be_true
      end
      it 'finds anagrams of a word' do
        subject.get_anagrams('cat').should == {"cat"=>["act", "tac"]}

      end
      it 'finds anagrams of multiple words' do
        subject.get_anagrams('cat toc').should ==
          {"cat"=>["act", "tac"], "toc"=>["oct", "cot"]}
      end
    end

    context 'clearing databae' do
      it 'flushes the database' do
        subject.empty_dictionary.should be_true
        subject.get_anagrams('cat').should be_empty
      end
    end
end

