class CreateOcrImages < ActiveRecord::Migration
  def change
    create_table :ocr_images do |t|
      t.text :content
    end
  end
end
