class StoresController < ApplicationController

  before_filter :authenticate 
  before_filter :correct_owner_user,  :only => [:edit, :update, :destroy]

  def index
    @stores = Store.all
    @store = Store.new
  end

  def show
    @store = Store.where(id: params[:id]).first
    @tag = Tag.new
  end

  def edit
    @store = Store.where(id: params[:id]).first
  end

  def update
    @store = Store.where(id: params[:id]).first
    @tag = Tag.new
    if @store.filename != params[:store][:filename]
      Store.rename(@store.filename, params[:store][:filename], @store.location)
    end
    if @store.location != params[:store][:location]
      Store.move(params[:store][:filename], @store.location, params[:store][:location])
    end
    @store.update_attributes(store_params)
    render 'show'
  end

  def destroy
    @store = Store.where(id: params[:id]).first
    Store.remove(@store.filename, @store.location)
    @store.destroy
    redirect_to stores_path
  end

  def upload
    Store.save(params[:store])
    @store = Store.new(public: params[:store][:public],
                       filename: params[:store][:file].original_filename.downcase,
                       location: params[:store][:location],
                       user_id: params[:store][:user_id])
    @store.save
    redirect_to stores_path
  end

  def download
    @store = Store.where(id: params[:id]).first
    if @store.public || !@store.public && correct_user?(@store.user)
      redirect_to "/data#{@store.location}/#{@store.filename}"
    else
      redirect_to root_path, :flash => {:error => "not autherised for this action"}
    end
  end

  private
  def store_params
    params.require(:store).permit(:public, :filename, :location)
  end

  def correct_owner_user
    @user = Store.find(params[:id]).user
    redirect_to(root_path) unless correct_user?(@user)
  end

end
