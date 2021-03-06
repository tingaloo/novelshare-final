class Book < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  validates :title, presence: true, length: {minimum: 3}
  validates :author, presence: true

  has_many :book_checkouts, dependent: :destroy

  def available? # the presenter calls this
    if most_recent_checkout
      most_recent_checkout.returned?
    else
      true
    end
  end

  def most_recent_checkout
    book_checkouts.order('return_deadline desc').first
  end


  private

  def destroy_book_checkouts
    BookCheckout.delete_all "book_id = #{id}"
  end
end
