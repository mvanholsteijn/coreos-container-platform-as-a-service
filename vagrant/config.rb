$num_instances=1
$vm_memory=1024
$vm_cpu=1
$update_channel='stable'
$expose_consul_tcp = true
$forwarded_ports = { 80 => 8080 }

$number_of_nfs_servers = 0

$new_discovery_url = 'https://discovery.etcd.io/new'

# delete the generated user_data on vagrant destroy
if File.exists?('user_data') && ARGV[0].eql?('destroy')
  File.delete('user_data')
end

# automatically replace the discovery token on 'vagrant up' 
if !File.exists?('user_data') && File.exists?('user_data.template') && ARGV[0].eql?('up')
  require 'open-uri'
  require 'yaml'
 
  token = open($new_discovery_url).read
 
  begin
    data = YAML.load(IO.readlines('user_data.template')[1..-1].join)
  rescue Exception => e
    puts "ERROR: reading user_data.template"  + e.message
    exit 
  end

  data['coreos']['etcd']['discovery'] = token

  yaml = YAML.dump(data)
  File.open('user_data', 'w') { |file| file.write("#cloud-config\n\n#{yaml}") }
end
