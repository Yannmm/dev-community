require 'rails_helper'

RSpec.feature "UserSettings", type: :feature do
  describe 'User Settings' do 
    before :each do 
      @user = create(:user)
      sign_in(@user)

      sleep 1
    end

    it 'should allow users to edit their personal information' do 
      visit "/member/#{@user.id}"

      sleep 2

      expect(page).to have_text(@user.name)
      expect(page).to have_text(@user.profile_title)
      expect(page).to have_text(@user.address)
      expect(page).to have_text(@user.about)

      find(:xpath, '//a[contains(@class, "edit-profile")]//i[contains(@class, "bi-pencil-fill")]').click
      sleep 5

      expect(page).to have_text('Edit your details')

      fill_in 'user_first_name', with: 'Marks'
      fill_in 'user_last_name', with: 'Anderson'
      fill_in 'user_city', with: 'Indore'
      fill_in 'user_state', with: 'MM'
      fill_in 'user_country', with: 'India'
      fill_in 'user_pincode', with: '1234567'
      fill_in 'user_profile_title', with: 'Advanced Java Developer'
      fill_in 'user_street_address', with: 'xxx11'

      sleep 2

      click_button 'Save Changes'

      expect(page).to have_current_path("/member/#{@user.id}")

      expect(page).to have_text('Marks Anderson')
      expect(page).to have_text('Advanced Java Developer')
      expect(page).to have_text('Indore, MM, India xxx11, 1234567')

      sleep 5
    end
  end
end
