class TagsController < ApplicationController

  before_filter :authenticate

  def create
    @tag = Tag.where(:name => params[:tag][:name]).first
    store = Store.find(params[:tag][:file])
    if @tag.nil?
      @tag = Tag.new(:name => params[:tag][:name])
      @tag.save
    end
    store.tags.push(@tag)
    redirect_to store_path(store)
  end

  def show
    @tag   = Tag.find(params[:id])
    @files = @tag.stores
  end

  def destroy
    @tag = Tag.find(params[:id])
    store = Store.find(params[:file])
    store.tags.delete(@tag)
    if @tag.stores.size == 0
      @tag.destroy
    end
    redirect_to store_path(store)
  end

end
