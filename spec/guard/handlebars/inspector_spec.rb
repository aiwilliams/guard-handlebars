require 'spec_helper'

describe Guard::Handlebars::Inspector do
  before do
    Dir.stub(:glob).and_return 'a.handlebars'
  end

  subject { Guard::Handlebars::Inspector }

  describe 'clean' do
    it 'removes duplicate files' do
      subject.clean(['a.handlebars', 'a.handlebars']).should == ['a.handlebars']
    end

    it 'remove nil files' do
      subject.clean(['a.handlebars', nil]).should == ['a.handlebars']
    end

    it 'removes non-handlebars files' do
      subject.clean(['a.handlebars', 'b.txt']).should == ['a.handlebars']
    end

    it 'frees up the list of handlebars script files' do
      subject.should_receive(:clear_handlebars_files_list)
      subject.clean(['a.handlebars'])
    end

  end
end
