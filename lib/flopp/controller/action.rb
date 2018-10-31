require 'hanami/controller'
require 'dry-validation'

module Flopp
  class Controller
    class Action
      include Hanami::Action

      def logged_in
        current_user
      end

      def authenticated
        current_user.authenticated?
      end

      def self.schema &block
        instance_variable_set( '@schema', Dry::Validation.Params &block )
      end

      def set_result
        @result = yield
      end

      def result
        @result
      end

      def set_schema_errors
        @schema_errors = yield
      end

      def schema_errors
        @schema_errors
      end

      def schema_errors?
        schema_errors.empty?
      end

      def set_output
        @output = yield
      end

      def output
        @output
      end

      def handle_unauthenticated
        halt 501
      end

      def handle_unauthorized
        halt 503
      end

      def handle_schema_errors( errors )
        halt 400, errors
      end

      def request( schema )
        return 200
      end

      def call( params )
        return handle_unauthenticated unless logged_in
        return handle_unauthorized unless authenticated

        set_result do
          schema.call( params )
        end

        set_schema_errors do
          result.messages
        end

        return handle_schema_errors( errors ) if schema_errors?

        set_output do
          result.output
        end

        return request( output )
      end
    end
  end
end
