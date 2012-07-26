class MainController < ApplicationController
  before_filter :authorize!, only: :welcome

  def index
  end

  def welcome
  end
end
