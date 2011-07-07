require 'spec_helper'

describe Guard::Handlebars::Template do
  let(:default_namespace) { 'Templates' }
  let(:template) { Guard::Handlebars::Template.new('my/template', "<p>'Hello'</p>", :engine => 'engine', :namespace => 'Namespace') }

  describe 'function' do
    it 'should be the template name' do
      template.function.should == 'template'
    end

    it 'should be the path when single node in path' do
      template = Guard::Handlebars::Template.new('template', '')
      template.function.should == 'template'
    end
  end

  describe 'compile' do
    subject { template.compile }

    it 'should escape the template content' do
      subject.should =~ /'<p>\\'Hello\\'<\/p>'/m
    end

    it 'should register a partial when file starts with underscore' do
      template = Guard::Handlebars::Template.new('_template', '')
      subject = template.compile
      subject.should =~ /Handlebars\.registerPartial\('template', template\);/
    end
  end
end
