# coding: utf-8
#
module NamedPrompt
  extend AmiVoice::DialogModule::Utility

  class << self
    #
    # Please build your prompt using session object.  The return variable
    # should be String or Array of audio filenames.
    # Here is an example.
    #
    def speech_input_prompts session
      if session[:result].blank?
        []
      else
        "#{session[:result]}"
      end
    end
  end
end
