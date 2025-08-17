# frozen_string_literal: true

require 'application_responder'

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end
