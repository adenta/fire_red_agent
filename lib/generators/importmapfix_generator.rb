# Usage:
#   rails generate dotenv
class ImportmapfixGenerator < Rails::Generators::Base
  def remove_importmap_rails_gem
    gemfile_path = 'Gemfile'
    gsub_file gemfile_path, /^gem\s+["']importmap-rails["'].*$/, ''
    run 'bundle install'
  end

  def update_ci_workflow
    ci_workflow_path = '.github/workflows/ci.yml'
    gsub_file ci_workflow_path, 'bin/importmap audit', 'npm audit'
  end

  def remove_importmap_comments
    application_js_path = 'app/javascript/application.js'
    gsub_file application_js_path, %r{//.*importmap.*\n}, ''

    controllers_index_js_path = 'app/javascript/controllers/index.js'
    gsub_file controllers_index_js_path, %r{//.*importmap.*\n}, ''
  end

  def remove_javascript_importmap_tags
    application_html_path = 'app/views/layouts/application.html.erb'
    gsub_file application_html_path, /<%= javascript_importmap_tags %>\n/, ''
  end

  def remove_importmap_bin
    remove_file 'bin/importmap'
  end

  def remove_importmap_config
    remove_file 'config/importmap.rb'
  end
end
