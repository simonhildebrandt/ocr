class ImagesController < ApplicationController

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
    redirect_to image_path(@ocr_image)
  end

  private

  def image_params
    params.require(:ocr_image).permit(:file)
  end
end
