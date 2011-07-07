module Guard
  class Handlebars

    class Template
      JS_ESCAPE_MAP = {
        "\r\n"  => '\n',
        "\n"    => '\n',
        "\r"    => '\n',
        '"'     => '\\"',
        "'"     => "\\'" }

      attr_reader :source

      def initialize(path, source, options = {})
        @path, @source = path, source
      end

      def compile
        # TODO Do not assume require.js, but make it possible
        compiled = "(function() {"
        compiled << "\n  define(['handlebars'], function() {"
        compiled << "\n    var #{function} = Handlebars.compile('#{escape(source)}');"
        compiled << "\n    Handlebars.registerPartial('#{function}', #{function});" if partial?
        compiled << "\n    return #{function};"
        compiled << "\n  });"
        compiled << "\n}).call(this);"

        compiled
      end

      def function
        name.sub(/^_/, '').split('.').first
      end

      def name
        @path.split('/').last
      end

      def partial?
        name =~ /^_/
      end

      private

      def escape(string)
        string.strip.gsub(/(\r\n|[\n\r"'])/) { JS_ESCAPE_MAP[$1] }
      end

    end

  end
end
