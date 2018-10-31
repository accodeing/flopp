require 'hanami/controller'
require 'dry-validation'

class Update
  include Hanami::Action

  Schema = Dry::Validation.Params do
    required(:uuid).filled

    required(:email).filled(format?: EMAIL_REGEX)

    required(:age).maybe(:int?)

    required(:address).schema do
      required(:street).filled
      required(:city).filled
      required(:zipcode).filled
    end
  end

  def call(params)
    halt 501 unless current_user
    halt 503 unless current_user.authenticated?

    errors = Schema.call(email: 'jane@doe.org', age: 19).messages

    return 400, errors unless errors.empty?

    @filereference = FileReferenceRepository.new.find(params[:uuid])
    return 500 unless @filereference.update(params).save

    return 200
  end
end
