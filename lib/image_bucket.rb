require 'aws-sdk'

class ImageBucket

  def bucket_name
    'my-ocr-' + Rails.env
  end

  def put(id, file, content_type)
    client.put_object(
      bucket: bucket_name,
      acl: 'public-read',
      key: id.to_s,
      body: file,
      content_type: content_type
    )
  end

  def url(id)
    get(id).public_url
  end

  def content_type(id)
    get(id).content_type
  end

  def destroy(id)
    client.delete_object(bucket: bucket_name, key: id.to_s)
  end

  def body(id)
    get(id).get.body.read
  end

  def get(id)
    Aws::S3::Object.new(bucket_name, id.to_s, client: client)
  end

  def client
    @client ||= Aws::S3::Client.new(s3_options)
  end

  def s3_options
    return {} unless Rails.env.development?
    YAML.load_file(Rails.root.join('config', 's3.yml')).deep_symbolize_keys
  end
end
