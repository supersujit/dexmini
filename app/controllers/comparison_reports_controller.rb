# frozen_string_literal: true

# Controller to manage and export the comparison reports
class ComparisonReportsController < ApplicationController
  def new
    robot_scan = RobotScan.find(params[:scan_id])
    @comparison_report = ComparisonReport.new(robot_scan:)
  end

  def show; end
end
