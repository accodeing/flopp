require 'lib/flopp/controller_action'

module FileReference
  module Controller
    class Update < Flopp::Controller::Action

      schema do
        required(:uuid).filled

        required(:target_status).included_in?([
          'pending',
          'unavailable',
          'available',
          'deleted'
        ])

        required(:metadata) jsonb,
      end

      def request( output )
        @filereference = FileReferenceRepository.new.find(output[:uuid])
        return 500 unless @filereference.update(output).save
        return 200
      end
    end
  end
end
