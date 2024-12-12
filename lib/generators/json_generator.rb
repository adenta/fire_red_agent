class JsonGenerator < Rails::Generators::Base
  def add_gems
    gemfile_path = 'Gemfile'
    gems = ['gem "blueprinter"', 'gem "oj"']

    gems.each do |gem_entry|
      next if File.readlines(gemfile_path).grep(/#{Regexp.escape(gem_entry)}/).any?

      append_to_file gemfile_path, "\n#{gem_entry}\n"
    end

    run 'bundle install'
  end

  def create_initializer
    initializer_path = 'config/initializers/generators.rb'
    initializer_content = <<~RUBY
      Rails.application.config.generators do |g|
        g.assets false
        # g.factory_bot true
        g.helper false
        g.orm :active_record, primary_key_type: :uuid
        g.stylesheets false
        # g.system_tests :rspec
        g.template_engine nil
        # g.test_framework :rspec
        # g.fixture_replacement :factory_bot, suffix_factory: 'factory'
      end
    RUBY

    create_file initializer_path, initializer_content
  end

  def create_blueprint_initializer
    initializer_path = 'config/initializers/blueprints.rb'
    initializer_content = <<~RUBY
      class LowerCamelTransformer < Blueprinter::Transformer
        def transform(hash, object, _options)
          hash.reverse_merge!({ id: object.try(:id), type: object&.class&.name })
          hash.transform_keys! { |key| key.to_s.camelize(:lower).to_sym }
        end
      end

      Oj.default_options = {
        mode: :custom,
        bigdecimal_as_decimal: true
      }

      Blueprinter.configure do |config|
        config.generator = Oj
        # JS used to not be able to parse ISO8601, leaving this out unless it becomes a problem.
        # I think if we send dates to typesense, we will still need dates to be numbers that can be sorted.
        # config.datetime_format = ->(datetime) { datetime.to_i * 1000 }
        config.default_transformers = [LowerCamelTransformer]
      end
    RUBY

    create_file initializer_path, initializer_content
  end

  def create_json_key_transform_initializer
    initializer_path = 'config/initializers/json_param_key_transform.rb'
    initializer_content = <<~RUBY
      # Transform JSON request param keys from JSON-conventional camelCase to
      # Rails-conventional snake_case:
      ActionDispatch::Request.parameter_parsers[:json] = lambda { |raw_post|
        # Modified from action_dispatch/http/parameters.rb
        data = ActiveSupport::JSON.decode(raw_post)

        # Transform camelCase param keys to snake_case
        if data.is_a?(Array)
          data.map { |item| item.deep_transform_keys!(&:underscore) }
        else
          data.deep_transform_keys!(&:underscore)
        end

        # Return data
        data.is_a?(Hash) ? data : { '_json': data }
      }
    RUBY

    create_file initializer_path, initializer_content
  end
end
