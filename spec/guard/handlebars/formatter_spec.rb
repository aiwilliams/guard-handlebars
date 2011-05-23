require 'spec_helper'

describe Guard::Handlebars::Formatter do

  subject { Guard::Handlebars::Formatter }

  describe '.info' do
    it 'output Guard::UI.info' do
      ::Guard::UI.should_receive(:info).once.with('a.handlebars', {})
      subject.info('a.handlebars')
    end
  end

  describe '.debug' do
    it 'output Guard::UI.debug' do
      ::Guard::UI.should_receive(:debug).once.with('a.handlebars', {})
      subject.debug('a.handlebars')
    end
  end

  describe '.error' do
    it 'colorize Guard::UI.error' do
      ::Guard::UI.should_receive(:error).once.with("\e[31ma.handlebars\e[0m", {})
      subject.error('a.handlebars')
    end
  end

  describe '.success' do
    it 'colorize Guard::UI.info' do
      ::Guard::UI.should_receive(:info).once.with("\e[32ma.handlebars\e[0m", {})
      subject.success('a.handlebars')
    end
  end

  describe '.notify' do
    it 'output Guard::Notifier.notify' do
      ::Guard::Notifier.should_receive(:notify).once.with('a.handlebars', {})
      subject.notify('a.handlebars')
    end
  end

end
