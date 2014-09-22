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
      run_on_modifications(Watcher.match_files(self, Dir.glob(File.join('**', '*.handlebars'))))
    end

    def run_on_modifications(paths)
      changed_files, success = Runner.run(Inspector.clean(paths), watchers, options)
      throw :task_has_failed unless success
    end
    
    def run_on_removals(paths)
      Runner.remove(Inspector.clean(paths, :missing_ok => true), watchers, options)
    end

  end
end
