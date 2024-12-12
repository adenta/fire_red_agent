#
# ViteGenerator is a Rails generator that adds the vite_rails gem to the Gemfile
# and installs Vite in a Rails application.
#
# Usage:
#   rails generate vite
#
# This generator performs the following actions:
#   1. Checks if the 'vite_rails' gem is already present in the Gemfile.
#   2. If not present, appends the 'vite_rails' gem entry to the Gemfile.
#   3. Runs 'bundle install' to install the gem.
#   4. Executes 'bundle exec vite install' to set up Vite in the Rails application.
class ViteGenerator < Rails::Generators::Base
  def add_vite_rails_gem
    gemfile_path = "Gemfile"
    gem_entry = 'gem "vite_rails"'

    unless File.readlines(gemfile_path).grep(/#{Regexp.escape(gem_entry)}/).any?
      append_to_file gemfile_path, "\n#{gem_entry}\n"
      run "bundle install"
    end

    run "bundle exec vite install"
  end
end
