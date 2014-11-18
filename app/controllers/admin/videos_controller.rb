class Admin::VideosController < AdminsController
  
  def new
    @video = Video.new
  end
  
  def create
    @video = Video.new(video_params)
    if @video.save
      @video.categories << Category.find(params[:category_id])
      flash[:success] = "You have succesfully added the video '#{@video.title}'"
      redirect_to new_admin_video_path
    else
      flash[:error] = "There was a problem with you inputs. Please check the errors "
      render :new
    end
  end
  
  private
  
  def video_params
    params.require(:video).permit(:title, :description, :small_cover, :large_cover, :video_url)
  end
  
end