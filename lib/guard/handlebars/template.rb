module Guard
  class Handlebars

    class Template
      JS_ESCAPE_MAP = {
        "\r\n"  => '\n',
        "\n"    => '\n',
        "\r"    => '\n',
        '"'     => '\\"',
        "'"     => "\\'" }

      attr_reader :engine, :exports, :source

      def initialize(path, source, options = {})
        @path, @source = path, source
        # TODO Test this
        @exports = options.has_key?(:exports) ? options[:exports] : 'window'
        @root_namespace = options[:namespace] || 'Templates'
        @engine = options[:engine] || 'Handlebars'
      end

      def compile
        function_path = "#{namespace.join('.')}.#{function}"

        # TODO Do not assume require.js, but make it possible
        compiled = "define(['handlebars'], function() {"
        compiled <<   "\n#{namespace_constructor}"
        compiled <<   "\n#{function_path} = #{engine}.compile(\n'#{escape(source)}'\n);"
        compiled <<   "\n#{engine}.registerPartial('#{function}', #{function_path});" if partial?
        compiled << "\n});"

        compiled
      end

      def function
        name.sub(/^_/, '')
      end

      def name
        @path.split('/').last
      end

      def namespace
        [@root_namespace].concat(@path.split('/') - [name])
      end

      def partial?
        name =~ /^_/
      end

      private

      def escape(string)
        string.strip.gsub(/(\r\n|[\n\r"'])/) { JS_ESCAPE_MAP[$1] }
      end

      def namespace_constructor
        previous = exports
        namespace.collect do |ns|
          current = [previous, ns].compact.join('.')
          previous = current
          "#{current} || (#{current} = {});"
        end.join
      end

    end

  end
end
