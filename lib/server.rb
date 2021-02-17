# -*- coding: utf-8 -*-
$LOAD_PATH << File.expand_path('lib', File.dirname(__FILE__))
require 'amivoice_dialog_module'
AmiVoice::DialogModule.root_path = File.expand_path('..', File.dirname(__FILE__))
AmiVoice::DialogModule::Initializer.init

require 'sinatra'
require 'amivoice_dialog_module/web'
use AmiVoice::DialogModule::Web
if AmiVoice::DialogModule::Settings.enable_prompt_uploader
  require 'amivoice_dialog_module/prompt_uploader_web'
  use AmiVoice::DialogModule::PromptUploaderWeb
end

set :public_folder, File.expand_path('../public', __dir__)
