class ResultsController < ApplicationController
  respond_to :html, :json
  def index
    #@results = Result.all
    #@json = Result.find_all_by_request_id(params[:request_id]).to_gmaps4rails
    req = Request.find_by_id(params[:request_id])
    arr = []
    req.desc.split(",").each do |id|
      begin
        arr << id.to_i
      end
    end
    @json = Place.find_all_by_id(arr).to_gmaps4rails
    respond_with @json
  end

  def show
    @result = Result.find(params[:id])
  end

  def new
    @result = Result.new
  end

  def create
    @result = Result.new(params[:result])
    if @result.save
      redirect_to @result, :notice => "Successfully created result."
    else
      render :action => 'new'
    end
  end

  def edit
    @result = Result.find(params[:id])
  end

  def update
    @result = Result.find(params[:id])
    if @result.update_attributes(params[:result])
      redirect_to @result, :notice  => "Successfully updated result."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @result = Result.find(params[:id])
    @result.destroy
    redirect_to results_url, :notice => "Successfully destroyed result."
  end
end
