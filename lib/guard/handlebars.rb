require 'guard'
require 'guard/guard'
require 'guard/watcher'

module Guard
  class Handlebars < Guard

    autoload :Formatter, 'guard/handlebars/formatter'
    autoload :Inspector, 'guard/handlebars/inspector'
    autoload :Runner, 'guard/handlebars/runner'
    autoload :Template, 'guard/handlebars/template'

    def initialize(watchers = [], options = {})
      watchers = [] if !watchers
      watchers << ::Guard::Watcher.new(%r{#{ options[:input] }/(.+\.handlebars)}) if options[:input]

      super(watchers, {
          :bare => false,
          :shallow => false,
          :hide_success => false,
          :compiled_name => 'compiled.js',
      }.merge(options))
    end

    def run_all
      run_on_change(Watcher.match_files(self, Dir.glob(File.join('**', '*.handlebars'))))
    end

    def run_on_change(paths)
      changed_files = Runner.run(Inspector.clean(paths), watchers, options)
      notify changed_files
    end

    private

    def notify(changed_files)
      ::Guard.guards.each do |guard|
        paths = Watcher.match_files(guard, changed_files)
        guard.run_on_change paths unless paths.empty?
      end
    end

  end
end
