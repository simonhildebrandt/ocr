require 'tesseract-ocr'
require 'rmagick'
require 'active_support/concern'

module Ocrable
  extend ActiveSupport::Concern

  class_methods do
    def resized_image(data)
      Magick::Image.from_blob(data).first.resize_to_fit(400, 200).negate.sigmoidal_contrast_channel().to_blob
    end
  end

  def resized_image
    self.class.resized_image(data)
  end

  def ocr_text_for_file
    engine.text_for(image).strip
  end

  def engine
    Tesseract::Engine.new do |e|
      e.language = :eng
      e.path = '/usr/share/tesseract-ocr/tessdata' if Rails.env.production?
      e.page_segmentation_mode = 8
      e.whitelist = ((0..9).to_a + ['-']).join
    end
  end
end
