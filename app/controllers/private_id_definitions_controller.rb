class PrivateIdDefinitionsController < ApplicationController
  def index
    @private_id_definitions = PrivateIdDefinition.all
  end

  def show
    @private_id_definition = PrivateIdDefinition.find(params[:id])
  end

  def new
    @private_id_definition = PrivateIdDefinition.new
  end

  def create
    @private_id_definition = PrivateIdDefinition.new(params[:private_id_definition])
    if @private_id_definition.save
      flash[:notice] = "Successfully created private id definition."
      redirect_to @private_id_definition
    else
      render :action => 'new'
    end
  end

  def edit
    @private_id_definition = PrivateIdDefinition.find(params[:id])
  end

  def update
    @private_id_definition = PrivateIdDefinition.find(params[:id])
    if @private_id_definition.update_attributes(params[:private_id_definition])
      flash[:notice] = "Successfully updated private id definition."
      redirect_to @private_id_definition
    else
      render :action => 'edit'
    end
  end

  def destroy
    @private_id_definition = PrivateIdDefinition.find(params[:id])
    @private_id_definition.destroy
    flash[:notice] = "Successfully destroyed private id definition."
    redirect_to private_id_definitions_url
  end
end
