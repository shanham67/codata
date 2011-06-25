class PartyNamesController < ApplicationController
  # GET /party_names
  # GET /party_names.xml
  def index
     @party_names = PartyName.search(params[:search]).paginate(:per_page => 50, :page => params[:page])
#    @party_names = PartyName.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @party_names }
    end
  end

  # GET /party_names/1
  # GET /party_names/1.xml
  def show
    @party_name = PartyName.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @party_name }
    end
  end

  # GET /party_names/new
  # GET /party_names/new.xml
  def new
    @party_name = PartyName.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @party_name }
    end
  end

  # GET /party_names/1/edit
  def edit
    @party_name = PartyName.find(params[:id])
  end

  # POST /party_names
  # POST /party_names.xml
  def create
    @party_name = PartyName.new(params[:party_name])

    respond_to do |format|
      if @party_name.save
        format.html { redirect_to(@party_name, :notice => 'Party name was successfully created.') }
        format.xml  { render :xml => @party_name, :status => :created, :location => @party_name }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @party_name.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /party_names/1
  # PUT /party_names/1.xml
  def update
    @party_name = PartyName.find(params[:id])

    respond_to do |format|
      if @party_name.update_attributes(params[:party_name])
        format.html { redirect_to(@party_name, :notice => 'Party name was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @party_name.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /party_names/1
  # DELETE /party_names/1.xml
  def destroy
    @party_name = PartyName.find(params[:id])
    @party_name.destroy

    respond_to do |format|
      format.html { redirect_to(party_names_url) }
      format.xml  { head :ok }
    end
  end
end
