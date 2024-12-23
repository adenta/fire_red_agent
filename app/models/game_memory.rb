class GameMemory < ApplicationRecord
  SYSTEM_ROLE = 'system'.freeze
  USER_ROLE = 'user'.freeze
  ASSISTANT_ROLE = 'assistant'.freeze

  MEMORY_ROLES = [SYSTEM_ROLE, USER_ROLE, ASSISTANT_ROLE].freeze

  validates :memory_role, presence: true, inclusion: { in: MEMORY_ROLES }
  validates :body, presence: true
end
