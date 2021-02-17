Getting Started
===============
This document describes next steps for developers.  See AmiVoice Dialog Module
Developer's Guide for more details.

## 1. edit gemspec
Open 'your_application_name.gemspec' and update summary, description and homepage.  You can leave it blank for homepage.
```
  spec.summary       = %q{TODO: Write a short summary, because Rubygems requires one.}
  spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
```

## 2. bundle
Install gem files from Internet.
```
$ bundle install
```
## 3. run server
```
$ rackup
```
Open web browser and access to 'http://localhost:9292'

When you need to expose this application to other machine, e.g. IVR server, please set option `-o 0.0.0.0`.
```
$ rackup -o 0.0.0.0
```

Stop rackup and move next step.

## 4. Commit your code to git
```
$ git init
$ git add -A
$ git commit -m "Initial commit"
```

## 5. Create your first dialog module
Create MainMenu dialog using `diamo generate` command.
```
$ diamo generate dialog_module MainMenu
       exist  app/dialog_modules
      create  test/app/dialog_modules
      create  app/dialog_modules/main_menu_dialog.rb
      create  test/app/dialog_modules/main_menu_dialog_test.rb
DialogModule 'MainMenuDialog' is successfully created
```

Note that below 4 commands result are same.  It will generate MainMenuDialog.
```
$ diamo generate dialog_module MainMenu
$ diamo generate dialog_module MainMenuDialog
$ diamo generate dialog_module main_menu
$ diamo generate dialog_module main_menu_dialog
```

## 6. Generate prompts
You can create prompts using TTS if you are working on mac.
```
$ diamo prompt tts
...../public/prompts/th-TH/welcome.wav
...../public/prompts/th-TH/please_say_yes_or_no.wav
...../public/prompts/th-TH/sorry_i_cannot_understand_you.wav
...../public/prompts/th-TH/sorry_i_cannot_understand_you_again.wav
...../public/prompts/th-TH/sorry_i_cannot_hear_you.wav
...../public/prompts/th-TH/sorry_i_cannot_hear_you_again.wav
...../public/prompts/th-TH/can_you_say_yes_or_no_again.wav
...../public/prompts/th-TH/can_you_say_again.wav
...../public/prompts/th-TH/is_it_correct.wav
...../public/prompts/th-TH/transfer_to_agent.wav
...../public/prompts/th-TH/service_unavailable.wav
```
For production, it's highly recommended to record by professional narrator or voice talent.

## 7. Configure entry point
Set first dialog_module name in 'config/dialplan_v2.rb'
```ruby
module DialogModule
  module DialPlanV2
    class << self
      def entry_point params, session, env
         MainMenuDialog
      end
    end
  end
end
```
If you want to change entry point based on caller number, dialed number or any business logic, you can implement it here.  At least, params contain followings.
```
params[:dnis]        ... Dialed number
params[:ani]         ... Caller number
params[:logging_tag] ... Logging tag
```
All other values depend on IVR platfrom and the settings.

## 8. Set entry point to your IVR server
Please see following URL on your IVR server.  See more details in the IVR
manual.
```
http://server:9292/main.vxml
```

## 9. Test call

TIPS
====
## Reload changed files automatically.
```
$ RACK_ENV=development rerun "bundle exec rackup"
```

## Test automation
```
$ RACK_ENV=test bundle exec guard
```
Now guard monitors all your changes to the source code and run unit
test automatically.

Run test manually.
```
$ rake test 2> /dev/null
```

diamo command
=============
## A. For development
### Create dialog module
```
$ diamo generate dialog_module YourDialogModuleName
```
### Create model
```
$ diamo generate model YourModelName
```
### Create block
```
$ diamo generate block YourBlockName
```
### Create play audio block
```
$ diamo generate play_audio_block YourBlockName
```
### Create integration test
```
$ diamo generate integration_test SenarioName
```
### Create prompts
```
$ diamo prompt tts
```
### Check prompt files
```
$ diamo prompt check
```

## B. For production
### Show Tunig Tools log
Show all transaction files which are failed to uploade to Tuning Tools server.
```
$ diamo log check
```
### Upload to Tunig Tools

```
$ diamo log recover
```

Install to production server
============================
### 1. Create package (@local machine)
Open console and move to your application root directory.
```
$ bundle package
$ cd ..
$ tar cvzf your-app-<version>.tgz your-app
```

### 2. Copy package file to production server
```
$ scp your-app-<version>.tgz user@server:/home/user
```

### 3. Install
```
$ ssh user@server
$ tar xvf your-app-<version>.tgz -C /opt
```

### 4. Configuration
```
$ cd /opt/your-app-<version>
$ bundle install --local
$ cp config/application.yml.sample config/application.yml
```
Change config/application.yml for your environment

### 5. Set task on cron
Set a cron task to recover tuning tools data which is not uploaded when the
server is not available by network error, server error, database error and
so on.

```
$ bundle exec whenever --update-crontab
```

By default, cron daemon checks recovery log on local disk in every minutes
to upload data to tuning tools server.  You can edit following file to
change the behaviour.  Then run above command again.

```
config/schedule.rb
```

### 6. Test
```
$ RACK_ENV=development bundle exec rackup
```

Integration Test
================
```
$ diamo generate integration_test normal_call
       exist  test/integration
      create  test/integration/normal_call_test.rb
Integration Test 'NormalCallTest' is successfully created
```

Edit test case

test/integration/normal_call_test.rb
```
class NormalCallTest < Minitest::Test
  def test_normal_call
    # TODO: Set appropriate initial dialog name and session object
    first_dialog = YourFirstDialog
    caller = TestCaller.new(first_dialog,
                            {
                              "dialog_state"=>"main",
                              "keywords" => [{}]
                            })
    # TODO: Compare expected initial prompt
    assert_equal ["your_init_prompt"],
                 caller.initial_prompt

    # TODO: Set recognition result
    caller.speak({ "result" => "yes" })

    # TODO: Compare expected next dialog name after caller's speech
    assert_equal ExpectedDialog, caller.dialog

    # TODO: Compare expected session after caller's speech
    assert_equal({},
                 caller.session)

    # TODO: Call speak and compare expected next dialog and session until
    # call end.
  end
end
```

Recover network error
=====================
When IVR cannot access to Tuning Tools server, it keeps all transaction logs such as call_detail_log,
dialog_log, prompt_log and task_log into local log file.  It's called as recovery log.

There are two diamo's sub command to manipulate recovery log.
```
diamo log show     # show call, dialog and task logs which is not uploaded to server yet
diamo log recover  # post call, dialog and task logs which is not uploaded to server yet
```

Firstly, you can see number of remaining information in each recovery logs.
```
$ diamo log show
/var/aminets/log/amivoice_dialog_module/call_detail_logs.json	2016-10-15 11:32:13	0
/var/aminets/log/amivoice_dialog_module/dialog_logs.json     	2016-10-15 11:32:13	0
/var/aminets/log/amivoice_dialog_module/task_logs.json       	2016-10-15 11:32:13	0
```

If there are data in recovery logs, you can just type:
```
$ diamo log recover
```
Then, all data will be uploaded to server and clear in recovery logs.

If there is no data in recovery logs, it shows just message and does not do anything.
```
$ diamo log recover
No recovery log or no data in the log
```

Cron Tasks
==========
Set a task on cron.
```
$ bundle exec whenever --update-crontab
```
It's saved in user's crontab, /var/spool/cron.
Type following command to check.
```
$ crontab -l
```
