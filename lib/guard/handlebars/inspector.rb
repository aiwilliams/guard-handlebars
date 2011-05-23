module Guard
  class Handlebars
    module Inspector
      class << self

        def clean(paths)
          paths.uniq!
          paths.compact!
          paths = paths.select { |p| handlebars_file?(p) }
          clear_handlebars_files_list
          paths
        end

      private

        def handlebars_file?(path)
          handlebars_files.include?(path)
        end

        def handlebars_files
          @handlebars_files ||= Dir.glob('**/*.handlebars')
        end

        def clear_handlebars_files_list
          @handlebars_files = nil
        end

      end
    end
  end
end
