module Flipper
  module Middleware
    class SetupEnv
      # Public: Initializes an instance of the SetEnv middleware. Allows for
      # lazy initialization of the flipper instance being set in the env by
      # providing a block.
      #
      # app - The app this middleware is included in.
      # flipper_or_block - The Flipper::DSL instance or a block that yields a
      #                    Flipper::DSL instance to use for all operations.
      #
      # Examples
      #
      #   flipper = Flipper.new(...)
      #
      #   # using with a normal flipper instance
      #   use Flipper::Middleware::SetEnv, flipper
      #
      #   # using with a block that yields a flipper instance
      #   use Flipper::Middleware::SetEnv, lambda { Flipper.new(...) }
      #
      def initialize(app, flipper_or_block)
        @app = app

        if flipper_or_block.respond_to?(:call)
          @flipper_block = flipper_or_block
        else
          @flipper = flipper_or_block
        end
      end

      def call(env)
        env['flipper'.freeze] ||= flipper
        @app.call(env)
      end

      private

      def flipper
        @flipper ||= @flipper_block.call
      end
    end
  end
end
