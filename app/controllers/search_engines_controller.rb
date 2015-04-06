class SearchEnginesController < ApplicationController
  def index
    @key_word = "write the keywords"
    @results = []
  end

  def search
    @key_word = params[:key_word][:key].downcase
    @results  = []
    keys = @key_word.split
    Store.all.each do |store|
      keys.each do |key|
        if store.filename.include? key
          @results.push(store)
          break
        end
      end
    end
    render 'index'
  end

end
