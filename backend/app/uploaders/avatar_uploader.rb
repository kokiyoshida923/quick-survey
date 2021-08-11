class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file if Rails.env.development? || Rails.env.test?

  def store_dir
    env = Rails.env
    return unless env.development? || env.test?

    "uploads_#{env}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def cache_dir
    env = Rails.env
    return unless env.development? || env.test?

    "uploads_#{env}/cache/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url(*args)
    "/images/fallback/#{[version_name, 'default.png'].compact.join('_')}"
  end

  def extension_allowlist
    %w[jpg jpeg gif png]
  end

  def size_range
    1.byte...10.megabytes
  end
end
