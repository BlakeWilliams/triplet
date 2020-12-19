# frozen_string_literal: true

Rails.application.routes.draw do
  get "/", to: "pages#show"
  get "/renderable", to: "pages#renderable"
end
