# frozen_string_literal: true

# Controller to manage and export the comparison reports
class ComparisonReportsController < ApplicationController
  def new
    robot_scan = RobotScan.find(params[:scan_id])
    @comparison_report = ComparisonReport.new(robot_scan:)
  end

  def show; end

  def generate
    render :new and return unless comparison_report_params[:file].present?

    manual_scan = ManualScan.create!(file: comparison_report_params[:file])
    @comparison_report = ComparisonReport.create!(robot_scan_id: comparison_report_params[:robot_scan_id],
                                                  manual_scan_id: manual_scan.id,
                                                  status: ComparisonReport.statuses[:pending])
    ProcessComparisonReportJob.perform_async(@comparison_report.id)
    redirect_to @comparison_report
  end

  private

  def comparison_report_params
    params.require(:comparison_report).permit(:robot_scan_id, :file)
  end

end
