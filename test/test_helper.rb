# coding: utf-8
$LOAD_PATH.unshift File.join(__dir__,"lib")
require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
require 'amivoice_dialog_module'
include AmiVoice::DialogModule
require 'amivoice_dialog_module/initializer'
AmiVoice::DialogModule.root_path = File.expand_path('..', File.dirname(__FILE__))
AmiVoice::DialogModule::Initializer.init

require 'sinatra'
require 'amivoice_dialog_module/web'
require 'amivoice_dialog_module/test_call'
require 'amivoice_dialog_module/test_caller' # for backward compatibility

def create_session session
  SessionMemory.new("test", session, no_error_message: true)
end
