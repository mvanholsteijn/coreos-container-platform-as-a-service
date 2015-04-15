$num_instances=3
$update_channel='stable'
$forwarded_ports = { 80 => 8080 }

#$ dd_api_key = '12325455'

$new_discovery_url='https://discovery.etcd.io/new'

# To automatically replace the discovery token on 'vagrant up'
# and the data dog api key

if File.exists?('user-data') && ARGV[0].eql?('up')
  require 'open-uri'
  require 'yaml'
 
  token = open($new_discovery_url).read
 
  data = YAML.load(IO.readlines('user-data')[1..-1].join)
  data['coreos']['etcd']['discovery'] = token

  if $dd_api_key
    updated = false
    datadog_env = { 'path' => '/etc/datadog.env', 'permission' => '0400', 'owner' => 'root', 'content' => 'DD_API_KEY=' + $dd_api_key }
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
  File.open('user-data', 'w') { |file| file.write("#cloud-config\n\n#{yaml}") }
end


