require 'spec_helper'

describe UsersController do
  describe 'Profile', type: :feature, js: true do
    before(:each) do
      @user = FactoryBot.create(:user, username: 'ssw', email: 'ssw@yeah.com', created_at: '02/02/2016')
      page.set_rack_session("warden.user.user.key": User.serialize_into_session(@user))
    end

    it 'sets page title appropriately' do
      visit "/users/#{@user.id}/profile"

      title = @user.username + "'s User Profile - Pinball Map"

      desc_tag = "meta[property=\"og:title\"][content=\"#{title}\"]"
      expect(page.body).to have_css(desc_tag, visible: false)
      expect(page.title).to eq(title)
    end

    it 'looks up by user_id or username' do
      title = @user.username + "'s User Profile - Pinball Map"

      visit "/users/#{@user.id}/profile"

      expect(page.title).to eq(title)

      visit "/users/#{@user.username}/profile"

      expect(page.title).to eq(title)
    end

    it 'display metrics about the users account' do
      FactoryBot.create(:user_submission, user: @user, location: FactoryBot.create(:location, id: 100), submission_type: UserSubmission::NEW_LMX_TYPE)
      FactoryBot.create(:user_submission, user: @user, location: Location.find(100), submission_type: UserSubmission::NEW_CONDITION_TYPE)
      FactoryBot.create(:user_submission, user: @user, location: FactoryBot.create(:location, id: 200), submission_type: UserSubmission::REMOVE_MACHINE_TYPE)
      FactoryBot.create(:user_submission, user: @user, location: FactoryBot.create(:location, id: 300), submission_type: UserSubmission::REMOVE_MACHINE_TYPE)
      FactoryBot.create(:user_submission, user: @user, submission_type: UserSubmission::SUGGEST_LOCATION_TYPE)
      FactoryBot.create(:user_submission, user: @user, submission_type: UserSubmission::SUGGEST_LOCATION_TYPE)
      FactoryBot.create(:user_submission, user: @user, submission_type: UserSubmission::SUGGEST_LOCATION_TYPE)
      FactoryBot.create(:user_submission, user: @user, location: FactoryBot.create(:location, id: 400), submission_type: UserSubmission::LOCATION_METADATA_TYPE)
      FactoryBot.create(:user_submission, user: @user, location: FactoryBot.create(:location, id: 500, name: 'Location One'), machine: FactoryBot.create(:machine, name: 'Machine One'), submission_type: UserSubmission::NEW_SCORE_TYPE, submission: 'ssw added a score of 1 for Machine One to Location One', created_at: '2016-01-02')

      FactoryBot.create(:user_submission, user: @user, location: Location.find(400), submission_type: UserSubmission::LOCATION_METADATA_TYPE)
      FactoryBot.create(:user_submission, user: @user, location: Location.find(500), machine: FactoryBot.create(:machine, name: 'Machine Two'), submission_type: UserSubmission::NEW_SCORE_TYPE, submission: 'ssw added a score of 2 for Machine Two to Location One', created_at: '2016-01-01')

      login
      visit "/users/#{@user.id}/profile"

      expect(page).to have_link('ssw')
      expect(page).to have_content('Member since: Feb-02-2016')
      expect(page).to have_content("1\nMachines Added")
      expect(page).to have_content("2\nMachines Removed")
      expect(page).to have_content("1\nMachine Comments")
      expect(page).to have_content("3\nLocations Submitted")
      expect(page).to have_content("5\nLocations Edited")
      expect(page).to have_content("High Scores (Last 50):\nMachine One\n1\nat Location One on Jan-02-2016\nMachine Two\n2\nat Location One on Jan-01-2016")
    end

    it 'adds commas to high scores' do
      FactoryBot.create(:user_submission, user: @user, location: FactoryBot.create(:location, id: 500, name: 'Location One'), machine: FactoryBot.create(:machine, name: 'Machine One'), submission_type: UserSubmission::NEW_SCORE_TYPE, submission: 'ssw added a score of 1000000 for Machine One to Location One', created_at: '2016-01-02')

      login
      visit "/users/#{@user.id}/profile"

      expect(page).to have_content("High Scores (Last 50):\nMachine One\n1,000,000\nat Location One on Jan-02-2016")
    end

    it 'Only lets you edit your own account' do
      not_your_user = FactoryBot.create(:user)

      login(@user)
      visit "/users/#{@user.id}/profile"

      expect(page).to have_content('Update email or password')

      visit "/users/#{not_your_user.id}/profile"

      expect(page).to_not have_content('Update email or password')
    end
  end
end
