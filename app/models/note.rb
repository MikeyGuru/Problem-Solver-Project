class Note < ActiveRecord::Base
  belongs_to :user
	belongs_to :problem

  after_create :send_email

  validates :comment, presence: true
  validates :problem, presence: true
  validates :user, presence: true

  validate :check_one_chosen_note_per_problem

  def check_one_chosen_note_per_problem
    return unless problem.present?

    if problem.resolved && self.chosen?
      errors.add(:chosen, "cannot be chosen because there is already a chosen note for that problem")
    end
  end

  def send_email
    if self.user != self.problem.user
      UserMailer.new_note(self.id).deliver
    end
  end
end
