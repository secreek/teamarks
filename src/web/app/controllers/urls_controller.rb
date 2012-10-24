# encoding: utf-8

class UrlsController < ApplicationController
  # GET /urls
  # GET /urls.json
  def index
    @urls = Url.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @urls }
    end
  end

  # GET /urls/1
  # GET /urls/1.json
  def show
    @url = Url.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @url }
    end
  end

  # GET /urls/new
  # GET /urls/new.json
  def new
    @url = Url.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @url }
    end
  end

  # GET /urls/1/edit
  def edit
    @url = Url.find(params[:id])
  end

  # POST /urls
  # POST /urls.json
  def create
    @url = Url.new(params[:url])

    respond_to do |format|
      if @url.save
        format.html { redirect_to @url, notice: 'Url was successfully created.' }
        format.json { render json: @url, status: :created, location: @url }
      else
        format.html { render action: "new" }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /urls/1
  # PUT /urls/1.json
  def update
    @url = Url.find(params[:id])

    respond_to do |format|
      if @url.update_attributes(params[:url])
        format.html { redirect_to @url, notice: 'Url was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /urls/1
  # DELETE /urls/1.json
  def destroy
    @url = Url.find(params[:id])
    @url.destroy

    respond_to do |format|
      format.html { redirect_to urls_url }
      format.json { head :no_content }
    end
  end

  # For URL APIs

  def share
    @err_msg = false
    poster = User.find(params[:userid])
    if poster.apikey == params[:apikey]
      @url = Url.new
      @url.description = params[:text]
      @url.page_title = params[:title]
      @url.url = params[:url]
      @url.user_id = poster.id
    else
      @err_msg = 'APIKEY does not match'
    end

    respond_to do |format|
      if @err_msg
        format.html {render json: { status: :failed, message: @err_msg }}
        format.xml {render xml: "<Result>谢特，貌似出问题了，请联系那群猴子们</Result>" }
      elsif @url.save
        format.html {render json: { entity: @url, status: :success }}
        format.xml {render xml: "<Result>分享成功这件事我会乱说？</Result>" }
      else
        format.html {render json: { status: :failed }}
        format.xml {render xml: "<Result>谢特，貌似出问题了，请联系那群猴子们</Result>" }
      end
    end
  end

  def list
    # 0 if params[:after] is not an int
    @after = params[:after].to_i

    @lists = []
    users = User.find(:all).to_a
    users.each do |user|
      partial_lists = Url.find(:all).select do |url|
        res = (url.id > @after and url.user_id == user.id)
      end
      @lists << {user_id: user.id, links: partial_lists}
    end

    respond_to do |format|
      # WARNING is this thread safe?
      format.html {render json: {result: @lists, last: Url.find(:all).max.id }}
    end
  end

end
