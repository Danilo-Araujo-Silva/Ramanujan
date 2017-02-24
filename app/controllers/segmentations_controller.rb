class SegmentationsController < ApplicationController
  before_action :set_segmentation, only: [:show, :edit, :update, :destroy]

  def initialize
    super
    @dictionary = Segmentation.dictionary
  end

  # GET /segmentations
  # GET /segmentations.json
  def index
    @segmentations = Segmentation.all
  end

  # GET /segmentations/1
  # GET /segmentations/1.json
  def show
    begin
      if @segmentation.query and @segmentation.parameters
        raw_query_array = JSON.parse(@segmentation.query)
        parameters_array = JSON.parse(@segmentation.parameters)
        where = Segmentation.build_where(raw_query_array, parameters_array)
        @contacts = Contact.where(where).order(:name, :email)
      end
    rescue JSON::ParserError => jpe
    end
  end

  # GET /segmentations/new
  def new
    @segmentation = Segmentation.new
  end

  # GET /segmentations/1/edit
  def edit
    recriate_meta_from_entity(@segmentation, false)
  end

  # POST /segmentations
  # POST /segmentations.json
  def create
    update_query_and_parameters_from_params(params)

    @segmentation = Segmentation.new(segmentation_params)

    respond_to do |format|
      if @segmentation.save
        format.html { redirect_to @segmentation, notice: 'A segmentação foi criada com sucesso.' }
        format.json { render :show, status: :created, location: @segmentation }
      else
        format.html { render :new }
        format.json { render json: @segmentation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /segmentations/1
  # PATCH/PUT /segmentations/1.json
  def update
    respond_to do |format|
      update_query_and_parameters_from_params(params)

      if @segmentation.update(segmentation_params)
        format.html { redirect_to @segmentation, notice: 'A segmentação foi alterada com sucesso.' }
        format.json { render :show, status: :ok, location: @segmentation }
      else
        recriate_meta_from_entity(@segmentation, true)

        format.html { render :edit }
        format.json { render json: @segmentation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /segmentations/1
  # DELETE /segmentations/1.json
  def destroy
    @segmentation.destroy
    respond_to do |format|
      format.html { redirect_to segmentations_url, notice: 'A segmentação foi removida com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_segmentation
      @segmentation = Segmentation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def segmentation_params
      params.require(:segmentation).permit(:title, :description, :query, :parameters)
    end

    def update_query_and_parameters_from_params(params)
      begin
        if params[:segmentation].key?(:meta)
          parsed = Segmentation.parse_from_raw_parameters(
            params[:segmentation][:meta]
          )
          params[:segmentation][:query] = parsed[:query].to_json
          params[:segmentation][:parameters] = parsed[:parameters].to_json
        end
      rescue Exception
      end
    end

    def recriate_meta_from_entity(segmentation, use_was)
      begin
        if use_was
          raw_query_array = JSON.parse(segmentation.query_was)
          parameters_array = JSON.parse(segmentation.parameters_was)
        else
          raw_query_array = JSON.parse(segmentation.query)
          parameters_array = JSON.parse(segmentation.parameters)
        end
        @meta = Segmentation.build_from_query_and_parameters(
          raw_query_array,
          parameters_array
        )
      rescue Exception
        @meta = []
      end
    end
end
