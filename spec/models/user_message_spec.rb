require 'spec_helper'

describe UserMessage do
  it { should validate_presence_of(:message) }
  it { should ensure_length_of(:message).is_at_most(140) }
end
