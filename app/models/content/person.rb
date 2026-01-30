class Content::Person < Perron::Resource
  # @rbs title: () -> String
  # @rbs era: () -> String
  # @rbs related: () -> Array[String]
  delegate :title, :era, :related, to: :metadata
end
