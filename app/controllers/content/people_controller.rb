class Content::PeopleController < ApplicationController
  #: () -> void
  def index
    @resources = Content::Person.all
  end

  #: () -> void
  def show
    @resource = Content::Person.find(params[:id])
  end
end
