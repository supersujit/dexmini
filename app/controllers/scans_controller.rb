# frozen_string_literal: true

# Controller to manage the scans
class ScansController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[create]
  include Pagination

  def index
    paginate_records(RobotScan.completed.all.order(created_at: :desc))
  end

  def create
    @scan = RobotScan.new(scan_params)
    @scan.filename = scan_params.fetch(:file)&.original_filename
    if @scan.save
      render json: { message: 'Robot Scan created successfully' }, status: :created
    else
      render json: { errors: @scan.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def scan_params
    params.require(:scan).permit(:file)
  end
end
