#
#
#
class AgentTransferBlock < AmiVoice::DialogModule::BlockBase

  class << self

    agent_transfer_prompts = ['transfer_to_agent']

    define_method :agent_transfer_prompts= do |prompts|
      agent_transfer_prompts = prompts
    end

    define_method :agent_transfer_prompts do
      agent_transfer_prompts
    end
  end
end
