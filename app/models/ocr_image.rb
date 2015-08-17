require 'image_bucket'
require 'mime/types'
require 'ocrable'

class OcrImage < ActiveRecord::Base

  include Ocrable

  before_destroy :clean_up_s3


  def url
    image_bucket.url(id)
  end

  def process!
    update_attributes content: ocr_text_for_file
  end

  def self.upload(file)
    create!.tap do |image|
      image.upload(resized_image(File.open(file.path).read), file.content_type)
    end
  end

  def upload(file, content_type)
    image_bucket.put(id, file, content_type)
  end

  private

  def clean_up_s3
    image_bucket.destroy(id)
  end

  def image
    data
  end

  def data
    image_bucket.body(id)
  end

  def filename
    "#{id}.#{file_extension}"
  end

  def image_bucket
    @image_bucket ||= ImageBucket.new
  end

  def content_type
    image_bucket.content_type(id)
  end

  def file_extension
    MIME::Types[content_type].first.extensions.first
  end

end
