class SecretsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: { message: "Very Secret", data: [1, 2, 3], user: current_user }, status: 200
  end
end
