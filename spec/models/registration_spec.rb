require 'spec_helper'

describe Registration do

  describe 'full_name' do
    specify { Factory.build(:registration, first_name: 'Wanda', middle_name: 'Hunt', last_name: 'Phelps', suffix: 'III').full_name.should == 'Wanda Hunt Phelps III' }
    specify { Factory.build(:registration, first_name: 'John', last_name: 'Smith').full_name.should == 'John Smith' }
  end

  describe 'saving previous data' do
    let(:reg) { Factory(:registration) }

    specify { reg.previous_data.should be_nil }
    it "should save previous value on update" do
      previous_first_name = reg.first_name
      reg.update_attributes(first_name: 'Mike')
      reg.reload
      reg.previous_data[:first_name].should == previous_first_name
    end
  end

  describe 'init_update_to' do
    let(:r) { FactoryGirl.create(:registration, :domestic_absentee) }

    it 'should handle no kind (no status change)' do
      r.init_update_to(nil)
      r.should be_absentee
      r.should be_residential
    end

    it 'should handle domestic_absentee' do
      r.init_update_to('domestic_absentee')
      r.should be_absentee
      r.should be_residential
    end

    it 'should handle residential_voter' do
      r.init_update_to('residential_voter')
      r.should_not be_absentee
      r.should be_residential
    end

    it 'should handle overseas' do
      r.init_update_to('overseas')
      r.should be_absentee
      r.should_not be_residential
    end
  end

  describe 'voter_type' do
    it 'should return nil for when voter_id is not present' do
      r = Registration.new
      r.voter_type.should be_nil
    end

    it 'should return overseas absentee' do
      r = FactoryGirl.create(:registration, :existing, :overseas)
      r.voter_type.should == "Overseas / Military Absentee"
    end

    it 'should return domestic absentee' do
      r = FactoryGirl.create(:registration, :existing, :domestic_absentee)
      r.voter_type.should == "Domestic Absentee"
    end

    it 'should return residential voter' do
      r = FactoryGirl.create(:registration, :existing, :residential_voter)
      r.voter_type.should == "Residential Voter"
    end
  end

end
