module Rack
  module Test
    class CookieJar
      def signed
        self
      end

      def permanent
        self
      end

      def encrypted
        self
      end
    end
  end
end
