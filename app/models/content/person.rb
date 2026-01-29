class Content::Person < Perron::Resource
  delegate :title, :era, :related, to: :metadata
end
