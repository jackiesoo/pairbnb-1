class ReservationsController < ApplicationController
	def new
		@reservation = Reservation.new(listing_id: params[:listing_id])
		@listing = Listing.find(params[:listing_id])
	end

	def create
		@reservation = Reservation.new(reservation_params)
		@reservation.user_id = current_user.id
		@reservation.listing_id = params[:listing_id]	
		@host = "jamesloh1991@gmail.com"	
		if @reservation.save
			redirect_to reservation_path(@reservation.id)
			ReservationMailer.notification_email(current_user.email, @host, @reservation.listing.id, @reservation.id).deliver_now
            # ReservationMailer to send a notification email after save
             # ReservationMailer.notification_email(current_user.email, @host, @reservation.listing.id, @reservation.id).deliver_later
		    ReservationJob.perform_later(current_user.email, @host, @reservation.listing.id, @reservation.id)
		    # call out reservation job to perform the mail sending task after @reservation is successfully saved
		else
			# error_message
			render :new
		end
	end  

	def destroy
	
	@reservation = Reservation.find_by(id: params[:id])
	# when use find by, can find_by id:, user_id:, place_name: etc
    @reservation.destroy
    respond_to do |format|
      format.html { redirect_to user_reservations_path(@reservation.user_id), notice: 'Listing was successfully destroyed.' }
      format.json { head :no_content }
      end
    end





	private
	def reservation_params	
		params.require(:reservation).permit(:start_date, :end_date)
	end
end





# class ReservationsController < ApplicationController
# 	before_action :authenticate_user!

# 	def preload
# 		room = Listing.find(params[:listing_id])
# 		today = Date.today
# 		reservations = listing.reservations.where("start_date >= ? OR end_date >= ?", today, today)

# 		render json: reservations	
# 	end

# 	def create
# 		@reservation = current_user.reservations.create(reservation_params)

# 		redirect_to @reservation.room, notice: "Your reservation has been created..."
# 	end

# 	private
# 		def reservation_params
# 			params.require(:reservation).permit(:start_date, :end_date, :price, :total, :room_id)
# 		end
# end



