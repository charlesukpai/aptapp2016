class ApartmentsController < ApplicationController
  before_action :set_apartment, only: [:show, :edit, :update, :destroy]
#Setting up our page so that non signed in users cannot edit or destroy apartment listings
  before_action :authenticate_user!, except: [:index, :show]

  # GET /apartments
  # GET /apartments.json
  #spent over 4hrs before figuring out my full map wasnt showing cos i didnt change @hash to @pindrop and @apartment to @apartments
  def index
    @apartments = Apartment.all
    @pindrop = Gmaps4rails.build_markers(@apartments) do |apartment, marker|
      marker.lat apartment.latitude
      marker.lng apartment.longitude
      marker.infowindow apartment.full_address
    end
  end

  def show
    @apartments = Apartment.find(params[:id])
      @pindrop = Gmaps4rails.build_markers(@apartments) do |apartment, marker|
        marker.lat apartment.latitude
        marker.lng apartment.longitude
        marker.infowindow apartment.full_address
      end
  end

def map_location
  @apartment = Apartment.find(params[:apartment_id])
  @hash = Gmaps4rails.build_markers(@apartment) do |apartment, marker|
    marker.lat apartment.latitude
    marker.lng apartment.longitude
    marker.infowindow apartment.full_address
  end
end
render json: @hash.to_json

  # GET /apartments/new
  def new
    @apartment = current_user.apartments.build
  end

  # GET /apartments/1/edit
  def edit
  end


  # POST /apartments
  # POST /apartments.json
  def create
    @apartment = current_user.apartments.build(apartment_params)

    respond_to do |format|
      if @apartment.save
        format.html { redirect_to @apartment, notice: 'Apartment was successfully created.' }
        format.json { render :show, status: :created, location: @apartment }
      else
        format.html { render :new }
        format.json { render json: @apartment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /apartments/1
  # PATCH/PUT /apartments/1.json
  def update
    respond_to do |format|
      if @apartment.update(apartment_params)
        format.html { redirect_to @apartment, notice: 'Apartment was successfully updated.' }
        format.json { render :show, status: :ok, location: @apartment }
      else
        format.html { render :edit }
        format.json { render json: @apartment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apartments/1
  # DELETE /apartments/1.json
  def destroy
    @apartment.destroy
    respond_to do |format|
      format.html { redirect_to apartments_url, notice: 'Apartment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_apartment
      @apartment = Apartment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def apartment_params
      params.require(:apartment).permit(:latitude, :longitude, :address, :street, :city, :postal_code, :state, :country, :landlord_name, :contact_number, :hours, :image, :username, :login)
    end
end
