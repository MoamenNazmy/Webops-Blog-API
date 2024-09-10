class Post < ApplicationRecord
  after_create :schedule_deletion
  belongs_to :user
  has_many :comments, dependent: :destroy
  validates :title, presence: true
  validates :body, presence: true
  validates :tags, presence: true


  private 

  def schedule_deletion
    PostDeletionJob.set(wait: 24.hours).perform_later(id)
  end


#Testing if the post will be deleted after 2 mins or not

=begin
   def schedule_deletion
    PostDeletionJob.set(wait: 2.minutes).perform_later(id) 
  end
=end
end
