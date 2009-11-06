class SprocketsController < ActionController::Base
	caches_page :show, :if => Proc.new { SprocketsApplication.use_page_caching }

	def index; show; end

	def show
		render :text => SprocketsApplication.new(params[:id]).source, :content_type => "text/javascript"
	end
end
