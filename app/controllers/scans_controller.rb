# frozen_string_literal: true

# Controller to manage the scans
class ScansController < ApplicationController
  def index; end

  def create
    @scan = RobotScan.new(scan_params)
    @scan.filename = scan_params.fetch(:file).original_filename
    if @scan.save
      render json: { message: 'Scan created successfully' }, status: :created
    else
      render json: { message: 'Problem!' }, status: :unprocessable_entity
    end
  end

  private

  def scan_params
    params.require(:scan).permit(:file)
  end
end