require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'manage investors' do

  context 'unauthenticated user' do

    scenario 'cannot manage investors' do
      visit '/'
      click_link 'Investors'
      page.should_not have_link 'New Investor'
      page.should_not have_link 'Edit'
      page.should_not have_link 'Destroy'
    end

  end # context

  context 'regular user' do

    scenario 'can create new investor' do
      investor = Investor.make
      market = Market.make!
      location = Location.make!
      investor.stage = nil
      login_normal
      click_link 'Investors'
      click_button 'New Investor'
      fill_in 'Name', :with => investor.name
      select 'VC', :from => 'Category'
      select 'active', :from => 'Status'
      select 'Series Seed', :from => 'Stages'
      select 'Series A', :from => 'Stages'
      select market.name, :from => 'Markets'
      select location.full, :from => 'Locations'
      expect do
        click_button 'Create Investor'
      end.to change {Investor.count}.by(1)
      page.should have_content 'Investor was successfully created.'
      page.should have_content investor.name
      click_link investor.name
      page.should have_content 'Series Seed, Series A'
    end

    scenario 'can edit investors' do
      investor = Investor.make!
      new_name = "#{investor.name} Clone"
      login_normal
      click_link 'Investors'
      click_link "edit_#{investor.id}"
      fill_in 'Name', :with => new_name
      select 'Series Seed', :from => 'Stages'
      unselect 'Series A', :from => 'Stages'
      expect do
        click_button 'Update Investor'
      end.to change {Investor.count}.by(0)
      page.should have_content 'Investor was successfully updated.'
      page.should have_content new_name
      page.should have_content 'Seed, Series Seed'
      page.should_not have_content 'Series A'
    end

    scenario 'can delete investors' do
      investor = Investor.make!
      login_normal
      click_link 'Investors'
      expect do
        click_link "destroy_#{investor.id}"
      end.to change {Investor.count}.by(-1)
      page.should have_content 'Investor was successfully deleted.'
      page.should_not have_content investor.name
    end

  end # context

end # feature
