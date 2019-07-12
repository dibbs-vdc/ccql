module Hyrax
  class Vdc::UsagesController < ApplicationController

    def index
      @resource = ::Vdc::Resource.find(params[:work_id])
      @vdc_usages = @resource.vdc_usages.order("created_at DESC").page params[:page]
    end
    
    def create
      @vdc_usage = ::Vdc::Usage.new(usage_params)
      if @vdc_usage.save
        respond_to do |format|
          format.html { redirect_to @vdc_usage.href }
          format.js 
          format.json { render json: @vdc_usage, status: :created }
        end        
      else
        render json: { errors: @vdc_usage.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

      def usage_params
        params.require(:vdc_usage).permit(:user_id, :work_id, :href, :purpose => [])
      end
  end
end