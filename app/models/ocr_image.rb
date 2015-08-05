require 'tesseract-ocr'
require 'image_bucket'

class OcrImage < ActiveRecord::Base

  def url
    ImageBucket.new.url(id)
  end

  def process!
    update_attributes content: ocr_text_for_file
  end

  def self.upload(file)
    create!.tap do |image|
      image.upload(file)
    end
  end

  def upload(file)
    ImageBucket.new.put(id, file)
  end

  def file
    ImageBucket.new.body(id)
  end

  private

  def ocr_text_for_file
    engine.text_for(file).strip
  end

  def engine
    Tesseract::Engine.new do |e|
      e.language = :eng
      e.page_segmentation_mode = 8
      e.whitelist = ((0..9).to_a + ['-']).join
    end
  end
end
