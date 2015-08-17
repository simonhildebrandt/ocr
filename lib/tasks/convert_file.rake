require 'image'

desc 'Convert a file'
task :convert, [:input_file_path] => :environment do |t, args|
  path = Rails.root.join(args[:input_file_path])
  Image.new(path).tap do |i|
    i.export(Rails.root.to_s)
  end
end

desc 'OCR a file'
task :ocr, [:input_file_path] => :environment do |t, args|
  path = Rails.root.join(args[:input_file_path])
  Image.new(path).tap do |i|
    puts i.ocr_text_for_file
  end
end

desc 'OCR all files'
task :all, [:input_path] => :environment do |t, args|
  pattern = "#{Rails.root.join(args[:input_path])}/*.jpg"
  Dir.glob(pattern).each do |path|
    Image.new(path).tap do |i|
      puts "#{i.filename} - #{i.ocr_text_for_file}"
    end
  end
end
