require 'open-uri'

class GamesController < ApplicationController
  def new
    alphabet = ("a".."z").to_a
    letters = []

    10.times { letters << alphabet.sample }
    @grid = letters
    @time = Time.now

  end

  def score
    word = params[:word]
    grid = params[:grid].chars
    start_time = DateTime.parse(params[:start])
    finish_time = Time.now
    letter_count = word.length

    @word = word
    @finish = (finish_time - start_time).round(2)
    @in_grid = in_grid?(word, grid) ? "Those letters are in the grid" : "NOT IN GRID"
    @english = english?(word) ? "That is in the dictionary" : "Not in the Dictionary"
    @points = points(word, @finish).round(2)

    unless in_grid?(word, grid) && english?(word)
      @points = 0
    end

  end

  private

  def in_grid?(attempt, grid)
    # break attempt into letters
    letters = attempt.downcase.chars
    # check if letters are in
    letters.all? { |char| letters.count(char) <= grid.count(char) }
  end

  def english?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt.downcase}"
    handled_url = open(url).read
    response = JSON.parse(handled_url)
    response["found"] == true
  end

  def points(attempt, time_taken)
    attempt.size * (1 - (time_taken / 60)).to_f
  end


end
