class KafkaClassificationSerializer < ActiveModel::Serializer
  def self.serialize(classification, options = {})
    serializer = new(classification)
    Serialization::V1Adapter.new(serializer, options)
  end

  attributes :id, :annotations, :created_at, :metadata

  belongs_to :project, serializer: KafkaProjectSerializer, embed: :ids
  belongs_to :user, serializer: KafkaUserSerializer
  belongs_to :workflow, serializer: KafkaWorkflowSerializer
  has_many   :subjects, serializer: KafkaSubjectSerializer, embed: :ids

  def metadata
    object.metadata.merge(workflow_version: object.workflow_version)
  end

  def subjects
    Subject.where(id: object.subject_ids)
  end
end
