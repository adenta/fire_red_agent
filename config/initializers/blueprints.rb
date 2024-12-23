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
