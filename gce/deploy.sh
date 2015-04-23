HOST=coreos
ZONE=gce.dutchdevops.net

sed -e "s^discovery: .*^discovery: $(curl -s https://discovery.etcd.io/new)^" \
	user-data > user-data.yml


gcloud compute instances create core-01 core-02 core-03 \
	--image https://www.googleapis.com/compute/v1/projects/coreos-cloud/global/images/coreos-stable-633-1-0-v20150414 \
	--machine-type n1-standard-1 \
	--metadata-from-file user-data=user-data.yml \
	--tags http-server

gcloud compute firewall-rules create http-access --allow tcp:80 --target-tags http-server --source-ranges 0.0.0.0/0

gcloud components update preview -q

gcloud compute http-health-checks create basic-check

gcloud compute target-pools \
    create coreos-http-pool \
    --health-check basic-check

gcloud compute target-pools \
	add-instances coreos-http-pool \
        --instances \
		core-01 \
		core-02 \
		core-03

gcloud compute forwarding-rules \
	create coreos-http-rule \
	--port-range 80 \
	--target-pool coreos-http-pool

IPADDRESS=$(gcloud compute forwarding-rules \
	describe coreos-http-rule \
	--format json | \
	jq -r .IPAddress)

gcloud dns managed-zones create gce-zone \
	--description="Google Compute Engine Zone for $ZONE"  \
	--dns-name="$ZONE."

gcloud dns record-sets transaction --zone gce-zone start
gcloud dns record-sets transaction --zone gce-zone add --name="$HOST.$ZONE." --type=A "$IPADDRESS" --ttl 300
gcloud dns record-sets transaction execute --zone gce-zone
rm transaction.yaml

