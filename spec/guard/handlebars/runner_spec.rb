require 'spec_helper'

describe Guard::Handlebars::Runner do
  describe '#run' do
    let(:runner)  { Guard::Handlebars::Runner }
    let(:watcher) { Guard::Watcher.new('^(.*)\.handlebars') }

    before do
      runner.stub(:compile).and_return ''
      FileUtils.stub(:mkdir_p)
      File.stub(:open)
    end

    it 'shows a start notification' do
      ::Guard::Handlebars::Formatter.should_receive(:info).once.with('Compile a.handlebars, b.handlebars', { :reset => true })
      ::Guard::Handlebars::Formatter.should_receive(:success).once.with('Successfully generated ')
      runner.run(['a.handlebars', 'b.handlebars'], [])
    end

    context 'without a shallow option' do
      let(:watcher) { Guard::Watcher.new(%r{src/.+\.handlebars}) }

      it 'compiles the Handlebars to the output file' do
        FileUtils.should_receive(:mkdir_p).with("#{ @project_path }/target")
        File.should_receive(:open).with("#{ @project_path }/target/a.js", 'w')
        runner.run(['src/a.handlebars'], [watcher], { :output => 'target' })
      end
    end

    context 'with the :shallow option set to false' do
      let(:watcher) { Guard::Watcher.new('^app/templates/(.*)\.handlebars') }

      it 'compiles the Handlebars to the output and creates nested directories' do
        FileUtils.should_receive(:mkdir_p).with("#{ @project_path }/javascripts/x/y")
        File.should_receive(:open).with("#{ @project_path }/javascripts/x/y/a.js", 'w')
        runner.run(['app/templates/x/y/a.handlebars'], [watcher], { :output => 'javascripts', :shallow => false })
      end
    end

    context 'with the :shallow option set to true' do
      let(:watcher) { Guard::Watcher.new('^app/templates/(.*)\.handlebars') }

      it 'compiles the Handlebars to the output without creating nested directories' do
        FileUtils.should_receive(:mkdir_p).with("#{ @project_path }/javascripts")
        File.should_receive(:open).with("#{ @project_path }/javascripts/a.js", 'w')
        runner.run(['app/templates/x/y/a.handlebars'], [watcher], { :output => 'javascripts', :shallow => true })
      end
    end

    context 'with compilation errors' do
      it 'shows the error messages' do
        runner.should_receive(:compile).and_raise RuntimeError.new("It could happen")
        ::Guard::Handlebars::Formatter.should_receive(:error).once.with("a.handlebars: It could happen")
        Guard::Notifier.should_receive(:notify).with("a.handlebars: It could happen", :title => 'Handlebars results', :image => :failed)
        runner.run(['a.handlebars'], [watcher], { :output => 'javascripts' })
      end
    end

    context 'without compilation errors' do
      it 'shows a success messages' do
        runner.should_receive(:compile).with('a.handlebars', { :output => 'javascripts' }).and_return ["OK", true]
        runner.should_receive(:notify_start).with(['a.handlebars'], { :output => 'javascripts' })
        ::Guard::Handlebars::Formatter.should_receive(:success).once.with('Successfully generated javascripts/a.js')
        Guard::Notifier.should_receive(:notify).with('Successfully generated javascripts/a.js', :title => 'Handlebars results')
        runner.run(['a.handlebars'], [watcher], { :output => 'javascripts' })
      end

      context 'with the :hide_success option set to true' do
        let(:watcher) { Guard::Watcher.new('^app/templates/(.*)\.handlebars') }

        it 'compiles the Handlebars to the output and creates nested directories' do
          FileUtils.should_receive(:mkdir_p).with("#{ @project_path }/javascripts/x/y")
          ::Guard::Handlebars::Formatter.should_not_receive(:success).with('Successfully generated javascripts/a.js')
          Guard::Notifier.should_not_receive(:notify).with('Successfully generated javascripts/a.js', :title => 'Handlebars results')
          runner.run(['app/templates/x/y/a.handlebars'], [watcher], { :output => 'javascripts', :hide_success => true })
        end
      end
    end

  end
end
