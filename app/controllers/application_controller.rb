# frozen_string_literal: true

class ApplicationController < ActionController::API

  rescue_from AccountService::Errors::NotFound do |exception|
    message = exception.message
    Rails.logger.error { exception.message }
    render json: message, status: :not_found
  end

  rescue_from AccountService::Errors::Blocked do |exception|
    message = exception.message
    Rails.logger.error { exception.message }
    render json: message, status: :unprocessable_entity
  end

  rescue_from AccountService::Errors::InsufficientFunds do |exception|
    message = exception.message
    Rails.logger.error { exception.message }
    render json: message, status: :unprocessable_entity
  end
end
