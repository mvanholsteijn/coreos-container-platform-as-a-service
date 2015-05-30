$num_instances=3
$update_channel='stable'
$expose_consul_tcp = true
$forwarded_ports = { 80 => 8080 }

$number_of_nfs_servers = 1

#$datadog_api_key = '12325455'

$new_discovery_url = 'https://discovery.etcd.io/new'

# To automatically replace the discovery token on 'vagrant up'
# and the data dog api key

if File.exists?('user_data') && ARGV[0].eql?('destroy')
  File.delete('user_data')
end

if !File.exists?('user_data') && File.exists?('user_data.template') && ARGV[0].eql?('up')
  require 'open-uri'
  require 'yaml'
 
  token = open($new_discovery_url).read
 
  data = YAML.load(IO.readlines('user_data.template')[1..-1].join)
  data['coreos']['etcd']['discovery'] = token

  if $datadog_api_key
    updated = false
    datadog_env = { 'path' => '/etc/datadog.env', 'permission' => '0400', 'owner' => 'root', 'content' => 'API_KEY=' + $datadog_api_key }
    if data['write_files'] 
        data['write_files'].each do |value| 
                if value['path'] == '/etc/datadog.env'
                        value['content'] = datadog_env['content']
                        updated = true
                end
        end
        if not updated
           data['write_files'] = data['write_files'] + [ datadog_env ]
        end
    else
       data['write_files'] = [ datadog_env ]
    end
  end

  yaml = YAML.dump(data)
  File.open('user_data', 'w') { |file| file.write("#cloud-config\n\n#{yaml}") }
end


