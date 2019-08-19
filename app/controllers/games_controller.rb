# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
# Class GamesController
class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
    @letters
  end

  def score
    grid = params[:letters].gsub(/\W/, '').split('')
    @score = 0
    if word_exist == 'false'
      @message = "Sorry, #{params[:word].upcase} is not an english word"
    elsif check_grid(params[:word], grid) && params[:word].present?
      @score = params[:word].length * 10
      @message = 'Well done!'
    else
      @message = "Sorry, but letters in the word #{params[:word].upcase} are not all in the grid #{grid}"
    end
    session[:score] = session[:score].present? ? session[:score] + @score : @score
  end

  def word_exist
    @url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    @url_reader = open(@url).read
    @word_exist = JSON.parse(@url_reader)

    @word_exist['found'].to_s
  end

  def check_grid(attempt, grid)
    word = attempt.upcase.chars
    count = 0
    word.each do |char|
      if grid.include?(char)
        grid.delete_at(grid.index(char))
        count += 1
      end
    end
    count == attempt.length
  end
end
