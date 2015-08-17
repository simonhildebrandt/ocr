class OcrImagesController < ApplicationController

  def index
    @images = OcrImage.all
  end

  def show
    @ocr_image = OcrImage.find(params[:id])
  end

  def new
    @ocr_image = OcrImage.new
  end

  def create
    @ocr_image = OcrImage.upload image_params[:file]
    @ocr_image.process!
    flash[:alert] = "Image created"
    redirect_to ocr_image_path(@ocr_image)
  end

  def destroy_all
    OcrImage.destroy_all
    render :index
  end

  private

  def image_params
    params.require(:ocr_image).permit(:file)
  end
end
