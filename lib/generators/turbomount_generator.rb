# Usage:
#   rails generate dotenv
class TurbomountGenerator < Rails::Generators::Base
  def add_turbo_mount_gem
    gemfile_path = 'Gemfile'
    gem_entry = 'gem "turbo-mount"'

    return if File.readlines(gemfile_path).grep(/#{Regexp.escape(gem_entry)}/).any?

    append_to_file gemfile_path, "\n#{gem_entry}\n"
    run 'bundle install'
  end

  def install_turbo_mount
    run 'bin/rails generate turbo_mount:install'
  end

  def install_packages
    run 'npm install @hotwired/turbo-rails'
  end

  # I don't think I installed stimulus correctly.
  # Probably had something to do with migrating the import map dependencies
end
