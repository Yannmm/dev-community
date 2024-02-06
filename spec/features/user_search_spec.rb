require 'rails_helper'

RSpec.feature "UserSearches", type: :feature do
  describe "User search functionality" do 
    before :each do 
      @user = create(:user)
      sign_in(@user)

      @user1 = create(:user, country: 'India', city: 'Indore')
      @user2 = create(:user, country: 'Austrilia', city: 'Sydney')
      @user3 = create(:user, country: 'England', city: 'London')
      @user4 = create(:user, country: 'USA', city: 'New York')
      @user5 = create(:user, country: 'China', city: 'Shanghai')

      sleep 1

    end

    describe 'search by country' do 
      it 'should allow user to search other users by complete country name' do 
        visit root_path 

        fill_in 'q_city_or_country_cont', with: 'China'
        click_button 'Serach'

        expect(page).to have_text(@user5.name)
        expect(page).to have_text(@user5.profile_title)
        expect(page).to have_text(@user5.country)

        expect(page).to_not have_text(@user1.name)
        expect(page).to_not have_text(@user2.profile_title)
        expect(page).to_not have_text(@user3.country)
      end 

      it 'should allow user to search other users by partial country name' do 
        visit root_path 

        fill_in 'q_city_or_country_cont', with: 'Aus'
        click_button 'Serach'

        expect(page).to have_text(@user2.name)
        expect(page).to have_text(@user2.profile_title)
        expect(page).to have_text(@user2.country)

        expect(page).to_not have_text(@user1.name)
        expect(page).to_not have_text(@user4.profile_title)
        expect(page).to_not have_text(@user3.country)
      end 

      it 'should allow user to search other users by any random character in the country name' do 
        visit root_path 

        fill_in 'q_city_or_country_cont', with: 'a'
        click_button 'Serach'

        expect(page).to have_text(@user1.name)
        expect(page).to have_text(@user1.profile_title)
        expect(page).to have_text(@user1.country)

        expect(page).to have_text(@user2.name)
        expect(page).to have_text(@user2.profile_title)
        expect(page).to have_text(@user2.country)

        expect(page).to have_text(@user3.name)
        expect(page).to have_text(@user3.profile_title)
        expect(page).to have_text(@user3.country)

        expect(page).to have_text(@user4.name)
        expect(page).to have_text(@user4.profile_title)
        expect(page).to have_text(@user4.country)

        expect(page).to have_text(@user5.name)
        expect(page).to have_text(@user5.profile_title)
        expect(page).to have_text(@user5.country)

        expect(page).to have_text(@user5.name)
        expect(page).to have_text(@user5.profile_title)
        expect(page).to have_text(@user5.country)

      end 
    end
  end
end
