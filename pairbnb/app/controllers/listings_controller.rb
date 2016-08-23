class ListingsController < ApplicationController
  before_action :set_listing, only: [:show, :edit, :update, :destroy]
  # User must be authneticated before every controller action, except for show
  # before_action :authenticate_user, except: [:show]


  def new
    @listing = Listing.new
  end

  def create
    @listing = current_user.listings.new(listing_params)
    @listing.user_id = current_user.id    
    if @listing.save
      redirect_to listings_path
    else
      # error_message
      render :new
    end
  end


  def index
    @listings = Listing.all
  end

  def search
        @listings = Listing.search(params[:term], fields: ["place_name", "address"], mispellings: {below: 5})
        if @listings.blank?
          redirect_to listings_path, flash:{danger: "no successful search result"}
        else
          render :index
        end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @listing.update(listing_params)
        format.html { redirect_to @listing, notice: 'Listing was successfully updated.' }
        format.json { render :show, status: :ok, location: @listing }
      else
        format.html { render :edit }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @listing.destroy
    respond_to do |format|
      format.html { redirect_to listings_url, notice: 'Listing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing
      @listing = Listing.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def listing_params
      params.require(:listing).permit(
        :user_id, :place_name, :place_type, :address, 
        :bedroom, :bath, :amenity, :cost_per_night,:description, {avatars:[]}  
        )
      # if want to create post, it need :user_id, :place_name, :place_type, :address, 
        # :bedroom, :bath, :amenity, :cost_per_night,:description   validation
    end











# class ListingsController < ApplicationController
#   before_action :set_listing, only:[:show, :update, :destroy, :edit]

#   def index
#     listings = Listing.where(user_id: current_user.id)
#     @listings = listings.order('id ASC')
#   end

#   def new
#     @listing = Listing.new
#     @address = Address.find(params[:address_id])
#   end

#   def create
#     @listing = Listing.new(listing_params)
#     @listing.address_id = params[:address_id]
#     @listing.user_id = current_user.id    
#     if @listing.save
#       redirect_to listings_path
#     else
#       # error_message
#       render :new
#     end
#   end

#   def edit
#   end

#   def update
#     if @listing.update_attributes(listing_params)
#       redirect_to listings_path
#     else
#       render 'edit'
#     end
#   end

#   def destroy
#     @listing.destroy
#     redirect_to listings_path
#   end

#   private
#   def listing_params  
#     params.require(:listing).permit(:place_name, :place_type, :address_id, :bedroom, :bath, :amenity, :cost_per_night, :description, {images:[]})
#   end

#   def set_listing
#     @listing = Listing.find(params[:id])
#   end
# end





