$num_instances=3
$update_channel='stable'
$forwarded_ports = { 80 => 8080 }

$new_discovery_url='https://discovery.etcd.io/new'

# To automatically replace the discovery token on 'vagrant up'

if File.exists?('user-data') && ARGV[0].eql?('up')
  require 'open-uri'
  require 'yaml'
 
  token = open($new_discovery_url).read
 
  data = YAML.load(IO.readlines('user-data')[1..-1].join)
  data['coreos']['etcd']['discovery'] = token
 
  yaml = YAML.dump(data)
  File.open('user-data', 'w') { |file| file.write("#cloud-config\n\n#{yaml}") }
end


