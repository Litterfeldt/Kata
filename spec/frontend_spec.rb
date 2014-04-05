# encoding: utf-8
require 'spec_helper'
require 'capybara/rspec'
require 'capybara-webkit'
require 'services/init'

Capybara.app = Kata::Server
describe Kata::Server do
  include Rack::Test::Methods

  before :all do
    Kata::Service::Anagram.new.add_dictionary_file(
      File.new('./spec/fixtures/dictionary.txt').read
    )
  end

  describe 'Seraching for anagrams', :type => :feature, :js => true do
    it "shows error if no anagrams are found" , :driver => :webkit do
      visit '/'
      fill_in 'SearchText', :with => 'rats'
      find("#search-button").click
      expect(page).to have_content 'Couldn’t find any anagrams'
    end

    it "shows success if no anagrams are found" , :driver => :webkit do
      visit '/'
      fill_in 'SearchText', :with => 'cat'
      find("#search-button").click
      expect(page).to have_content 'Found some anagrams'
    end
  end
end
