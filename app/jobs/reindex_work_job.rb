class ReindexWorkJob < ApplicationJob
  queue_as :default

  def perform(*works)
    works.each do |work|
      work.update_index
    end
  end
end
