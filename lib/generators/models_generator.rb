class ModelsGenerator < Rails::Generators::Base
  def add_to_application_record
    application_record_path = 'app/models/application_record.rb'
    insert_into_file application_record_path, before: /^end/ do
      <<~RUBY

        before_create :generate_uuid

        self.implicit_order_column = 'created_at'

        def generate_uuid
          self.id = SecureRandom.uuid
        end
      RUBY
    end
  end

  def install_activestorage
    run 'bin/rails active_storage:install'
    run 'bin/rails db:migrate'
  end

  def add_activestorage_initializer
    initializer_path = 'config/initializers/activestorage_patch.rb'
    create_file initializer_path, <<~RUBY
      # Monkeypatch ActiveStorage::Blob to add custom behavior

      Rails.application.config.to_prepare do
        module SetIdPatch
          extend ActiveSupport::Concern

          included do
            before_create :set_id_if_missing
          end

          private

          def set_id_if_missing
            self.id ||= SecureRandom.uuid
          end
        end

        # Include the patch in ActiveStorage::Blob
        ActiveStorage::Blob.include(SetIdPatch)
        ActiveStorage::Attachment.include(SetIdPatch)
        ActiveStorage::VariantRecord.include(SetIdPatch)
      end
    RUBY
  end
end
