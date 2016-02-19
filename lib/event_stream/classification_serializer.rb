require 'serialization/v1_adapter'

module EventStream
  class ClassificationSerializer < ActiveModel::Serializer
    def self.serialize(classification, options = {})
      serializer = new(classification)
      Serialization::V1Adapter.new(serializer, options)
    end

    attributes :id, :created_at, :updated_at, :user_ip, :annotations, :metadata

    belongs_to :project,  serializer: EventStream::ProjectSerializer
    belongs_to :user,     serializer: EventStream::UserSerializer
    belongs_to :workflow, serializer: EventStream::WorkflowSerializer
    has_many   :subjects, serializer: EventStream::SubjectSerializer

    def user_ip
      object.user_ip.to_s
    end

    def metadata
      object.metadata.merge(workflow_version: object.workflow_version)
    end
  end
end
