# TODO: I don't think I'm using this, am I?
class CvFile < ActiveRecord::Base
  mount_uploader :file, CvFileUploader
end
