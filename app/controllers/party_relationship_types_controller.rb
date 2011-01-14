class PartyRelationshipTypesController < ApplicationController
  # GET /party_relationship_types
  # GET /party_relationship_types.xml
  def index
    @party_relationship_types = PartyRelationshipType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @party_relationship_types }
    end
  end

  # GET /party_relationship_types/1
  # GET /party_relationship_types/1.xml
  def show
    @party_relationship_type = PartyRelationshipType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @party_relationship_type }
    end
  end

  # GET /party_relationship_types/new
  # GET /party_relationship_types/new.xml
  def new
    @party_relationship_type = PartyRelationshipType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @party_relationship_type }
    end
  end

  # GET /party_relationship_types/1/edit
  def edit
    @party_relationship_type = PartyRelationshipType.find(params[:id])
  end

  # POST /party_relationship_types
  # POST /party_relationship_types.xml
  def create
    @party_relationship_type = PartyRelationshipType.new(params[:party_relationship_type])

    respond_to do |format|
      if @party_relationship_type.save
        format.html { redirect_to(@party_relationship_type, :notice => 'Party relationship type was successfully created.') }
        format.xml  { render :xml => @party_relationship_type, :status => :created, :location => @party_relationship_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @party_relationship_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /party_relationship_types/1
  # PUT /party_relationship_types/1.xml
  def update
    @party_relationship_type = PartyRelationshipType.find(params[:id])

    respond_to do |format|
      if @party_relationship_type.update_attributes(params[:party_relationship_type])
        format.html { redirect_to(@party_relationship_type, :notice => 'Party relationship type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @party_relationship_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /party_relationship_types/1
  # DELETE /party_relationship_types/1.xml
  def destroy
    @party_relationship_type = PartyRelationshipType.find(params[:id])
    @party_relationship_type.destroy

    respond_to do |format|
      format.html { redirect_to(party_relationship_types_url) }
      format.xml  { head :ok }
    end
  end
end
