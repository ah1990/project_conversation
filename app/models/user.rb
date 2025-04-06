class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :comments, dependent: :destroy
  has_many :status_changes, dependent: :destroy
  has_many :conversation_entries, dependent: :destroy
  
  validates :name, presence: true
  
  def display_name
    name.presence || email.split('@').first
  end
end
