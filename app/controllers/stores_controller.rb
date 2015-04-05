class StoresController < ApplicationController

  def index
    @stores = Store.all
    @store = Store.new
  end

  def show
    @store = Store.where(id: params[:id]).first
  end

  def edit
    @store = Store.where(id: params[:id]).first
  end

  def update
    @store = Store.where(id: params[:id]).first

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
                       location: params[:store][:location])
    @store.save
    redirect_to stores_path
  end

  def download
    @store = Store.where(id: params[:id]).first
    redirect_to "/data#{@store.location}/#{@store.filename}"
  end
  private
  def store_params
    params.require(:store).permit(:public, :filename, :location)
  end

end
