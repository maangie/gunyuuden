class Content::PeopleController < ApplicationController

  def index
    @resources = Content::Person.all
  end

  def show
    @resource = Content::Person.find(params[:id])
  end
end
