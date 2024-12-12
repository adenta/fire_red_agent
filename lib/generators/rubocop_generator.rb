# Usage:
#   rails generate rubocop
#

class RubocopGenerator < Rails::Generators::Base
  def add_rubocop_gem
    gemfile_path = "Gemfile"
    gem_entry = 'gem "rubocop", require: false'

    gem_group = "group :development, :test do\n"

    unless File.readlines(gemfile_path).grep(/#{Regexp.escape(gem_entry)}/).any?
      inject_into_file gemfile_path, "  #{gem_entry}\n", after: gem_group
      run "bundle install"
    end
  end

  def remove_rubocop_gem
    gemfile_path = "Gemfile"
    gem_entry = 'gem "rubocop-rails-omakase", require: false'

    gsub_file(gemfile_path, /^.*#{Regexp.escape(gem_entry)}.*\n/, "")
    run "bundle install"
  end

  def remove_omakase_from_rubocop_yml
    rubocop_yml_path = ".rubocop.yml"

    if File.exist?(rubocop_yml_path)
      gsub_file(rubocop_yml_path, /^.*omakase.*\n/) { |match| "# #{match}" }
    end
  end
end
