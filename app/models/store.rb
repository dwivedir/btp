# == Schema Information
#
# Table name: stores
#
#  id         :integer          not null, primary key
#  public     :boolean
#  filename   :string(255)
#  location   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'fileutils'
class Store < ActiveRecord::Base
  belongs_to :user
  @@home = "#{Rails.root}/public/data"

  def self.empty_dir(local_dir)   # local directory is like "/1/home"
    local_dir = File.join(@@home, local_dir)
    if File.directory? local_dir
      FileUtils.rm_rf(Dir.glob("#{local_dir}/*"))
    end
  end

  def self.make_dir(local_dir)
    if !File.directory? local_dir
      FileUtils::mkdir_p local_dir
    end
  end

  def self.make_local_dir(dir)
    local_dir = File.join(@@home, dir)
    make_dir(local_dir)
  end

  def self.move(filename, pre_dest, next_dest)
    local_dir = File.join(@@home, "#{next_dest}")
    make_dir(local_dir)
    filename = File.join(@@home, "#{pre_dest}/#{filename}")
    FileUtils.mv(filename, local_dir)
  end

  def self.save(upload)
    filename = upload['file'].original_filename.downcase
    destination = upload['location']
    local_dir = File.join(@@home, "#{destination}")
    make_dir(local_dir)
    path = File.join(local_dir, filename)
    File.open(path, "wb") do |f|
      f.write(upload['file'].read)
    end
  end

  def self.remove(filename, location)
    file = File.join(@@home, "#{location}/#{filename}")
    File.delete(file)
  end

  def self.rename(filename1, filename2, location)
    local_dir = File.join(@@home, "#{location}")
    FileUtils.mv("#{local_dir}/#{filename1}", "#{local_dir}/#{filename2}")
  end

  def self.filePath(filename, location)
    local_dir = File.join(@@home, "#{location}/#{filename}")
  end
end
