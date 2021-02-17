set :output, '/var/aminets/log/virtual_agent_compact_app/cron.log'

every 1.minutes do
  command "cd /Users/Apisak/Desktop/Virtual Agent Compact Project/call_flow_app/virtual_agent_compact_app && RACK_ENV=production diamo log recover --silent"
end
