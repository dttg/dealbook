require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'display companies' do
  
  context 'guest' do

    scenario 'no companies' do
      visit '/'
      click_link 'Companies'
      page.should have_content 'No companies yet'
    end
    
    scenario 'one or more companies' do
      company = Company.make!
      visit '/'
      click_link 'Companies'
      page.should have_content company.name
      page.should_not have_content 'No companies yet'
    end

    scenario 'show company' do
      company = Company.make!
      visit '/'
      click_link 'Companies'
      click_link company.name
      page.should have_content company.name
      page.should have_content company.description
      page.should have_content company.website
      page.should have_content company.linkedin
      page.should have_content company.status          
      #TODO: include markets, locations
      page.should_not have_link 'Add new deal'
      page.should_not have_link 'Edit'
      page.should_not have_link 'Destroy'      
      page.should have_link 'Back'
    end
  end

  context 'user' do
    scenario 'show company' do
      company = Company.make!
      login_normal
      click_link 'Companies'
      click_link company.name
      page.should have_content company.name
      page.should have_content company.description
      page.should have_content company.website
      page.should have_content company.linkedin
      page.should have_content company.status          
      #TODO: include markets, locations
      page.should have_link 'Add new deal'
      page.should have_link 'Edit'
      page.should have_link 'Destroy'
      page.should have_link 'Back'
      click_link 'Add new deal'
      page.should have_content 'Create new deal'
      uri = URI.parse(current_url)
      uri.path.should == "/deals/new"     
    end
  end
end



