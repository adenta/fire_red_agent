class UserGenerator < Rails::Generators::Base
  def create_user_model
    generate 'model', 'user', 'clerk_id:string:uniq'
    rake 'db:migrate'
  end

  def install_clerk_gem
    gemfile_path = 'Gemfile'
    gem_entry = 'gem "clerk-sdk-ruby", require: "clerk"'

    return if File.readlines(gemfile_path).grep(/#{Regexp.escape(gem_entry)}/).any?

    append_to_file gemfile_path, "\n#{gem_entry}\n"
    Bundler.with_unbundled_env do
      run 'bundle install'
    end
  end

  def create_clerk_initializer
    initializer 'clerk.rb' do
      <<-RUBY
        Clerk.configure do |c|
          c.api_key = ENV['CLERK_SECRET_KEY']
          c.publishable_key = ENV['VITE_CLERK_PUBLISHABLE_KEY']
          c.logger = Logger.new(STDOUT)
        end
      RUBY
    end
  end

  def create_secured_concern
    create_file 'app/controllers/concerns/secured.rb', <<-FILE
  # frozen_string_literal: true

  module Secured
    extend ActiveSupport::Concern

    def current_user
      return nil if clerk_id.blank?

      user = User.where(clerk_id:).first

      if user.blank?
        user = User.create!(
          clerk_id:,
        )
      end

      user
    end

    def clerk_struct
      @clerk_struct ||= OpenStruct.new(clerk_user)
    end

    def clerk_id
      return if clerk_user.blank?

      clerk_struct.id
    end
  end
    FILE
  end

  def update_application_controller
    gsub_file 'app/controllers/application_controller.rb',
              /class ApplicationController < ActionController::Base.*?end/m do
      <<-RUBY
    require 'clerk/authenticatable'

    class ApplicationController < ActionController::Base
    include Clerk::Authenticatable
    include Secured

    skip_before_action :verify_authenticity_token, unless: :csrf_required?

    def csrf_required?
      clerk_user.nil?
    end
    end
      RUBY
    end
  end
end
