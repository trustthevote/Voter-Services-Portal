step 'I should see :message' do |msg|
  page.should have_content msg
end

step 'I should not see :message' do |msg|
  page.should_not have_content msg
end

step 'I am on the front page' do
  visit root_path
end
