class DotenvGenerator < Rails::Generators::Base
  def add_vite_rails_gem
    gemfile_path = 'Gemfile'
    gem_entry = 'gem "dotenv"'

    return if File.readlines(gemfile_path).grep(/#{Regexp.escape(gem_entry)}/).any?

    append_to_file gemfile_path, "\n#{gem_entry}\n"
    run 'bundle install'
  end

  def create_dotenv_file
    dotenv_path = '.env'
    return if File.exist?(dotenv_path)

    create_file dotenv_path, <<~ENV
      #{'  '}
    ENV
  end
end
