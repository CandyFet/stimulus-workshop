# frozen_string_literal: true

class ApplicationReflex < StimulusReflex::Reflex
  include Dry::Effects::Handler.State(:current_user)
  include Dry::Effects::Handler.State(:current_track)

  include Dry::Effects.State(:current_track)

  around_reflex :set_current_user, :set_current_track

  private

  def set_current_user
    with_current_user(connection.user) { yield }
  end

  def set_current_track
    track = Track.find_by(id: session[:track_id])
    with_current_track(track) { yield }
  end

  def component(name, **kwargs)
    component_class = "#{name.camelize}::Component".constantize

    ApplicationController.render(component_class.new(**kwargs), layout: false)
  end
end
