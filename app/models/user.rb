class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :projects
  has_many :project_members
  has_many :child_tasks

  has_one_attached :profile_image

  validates :display_name, presence: true
  validates :user_name, presence: true, uniqueness: true, format: { with: /\A[a-z0-9-]+\z/, message: "は半角英数字で入力してください。" }
  validates :email, presence: true, uniqueness: true
  validates :is_deleted, inclusion: [true, false]

  def my_task_refinement(refinement)
    if refinement.nil?
      self.child_tasks.where.not(progress: 100)
    elsif refinement == "all"
      self.child_tasks
    elsif refinement == "complete"
      self.child_tasks.where(progress: 100)
    elsif refinement == "remaining"
      self.child_tasks.where.not(progress: 100)
    end
  end

  def check_deleted
    if self.is_deleted
      "無効"
    else
      "有効"
    end
  end

  def self.select_deleted
    select_deleted = [['有効', false], ['無効', true]]
  end

  def task_count
    self.child_tasks.count
  end

  def task_complete
    self.child_tasks.where(progress: 100).count
  end

  def task_remaining
    task_count - task_complete
  end

  def task_progress
    sum_progress = self.child_tasks.sum(:progress)
    count_tasks = self.child_tasks.count
    if count_tasks == 0
      0
    elsif sum_progress == 0
      0
    else
      (sum_progress/count_tasks).floor
    end
  end

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_fill: [width, height]).processed
  end

  def self.guest
    find_or_create_by!(user_name: 'guestuser') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.display_name = "ゲストユーザー"
      user.email = "guest@example.com"
    end
  end

end
