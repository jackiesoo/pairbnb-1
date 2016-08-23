class Listing < ActiveRecord::Base
	  belongs_to :user
	  mount_uploaders :avatars, AvatarUploader
	  searchkick match: :word_start, searchable: [:place_name, :address]


end
