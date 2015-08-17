require 'ocrable'

class Image
  include Ocrable

  attr_accessor :path

  def initialize(path)
    @path = path
  end

  def data
    File.open(path).read
  end

  def image
    resized_image
  end

  def export(export_path)
    File.open(export_file(export_path), "wb") { |h| h.write(image) }
  end

  def export_file(path)
    File.join(path, filename)
  end

  def filename
    File.basename(path)
  end
end
