require 'rails_helper'

RSpec.feature "WorkExperiences", type: :feature do
  describe 'Work Experiences' do 
    describe 'Current user' do 
      before :each do 
        @user = create(:user)
        sign_in(@user)
        sleep 1
      end

      it 'should open the work experience form and display the validation errors if empty form is submitted' do 
        visit "/member/#{@user.id}"
        expect(page).to have_text('Work Experiences')
        find('a[data-controller="bs-modal-form"] i.bi.bi-plus').click
        sleep 1

        expect(page).to have_text('Add new work experience')

        click_button 'Save Changes'

        sleep 5
        expect(page).to have_text('9 errors prohibited your work experience from being saved.')
        expect(page).to have_text("Company can't be blank")
        expect(page).to have_text("Start date can't be blank")
        expect(page).to have_text("Job title can't be blank")
        expect(page).to have_text("Location can't be blank")
        expect(page).to have_text("Employment type can't be blank")
        expect(page).to have_text("Employment type not a valid employment type")
        expect(page).to have_text("Location type can't be blank")
        expect(page).to have_text("Location type not a valid location type")
        expect(page).to have_text("End date must be present if you are not currently working in this company")

        sleep 2
      end
    end
  end
end
