require 'rails_helper'

RSpec.describe DefaultAdminSetService do

  describe "#run" do

    xit "sets the default workflow for the default admin set" do
      described_class.run
      expect(AdminSet.where(id: "admin_set/default")).not_to eq []
    end
  end
end