export HOST=coreos
export ZONE=gce.dutchdevops.net

IPADDRESS=$(gcloud compute forwarding-rules \
        describe coreos-http-rule \
        --format json | \
        jq -r .IPAddress)

if [ -n "$IPADDRESS" ]  ; then
	gcloud dns record-sets transaction start --zone gce-zone
	gcloud dns record-sets transaction remove $IPADDRESS --name="$HOST.$ZONE."  --type=A --ttl=0 --zone gce-zone
	gcloud dns record-sets transaction execute --zone gce-zone
fi

gcloud dns managed-zones delete gce-zone  -q

gcloud compute forwarding-rules delete coreos-http-rule  -q

gcloud compute target-pools delete coreos-http-pool  -q

gcloud compute http-health-checks delete basic-check -q

gcloud compute firewall-rules delete http-access  -q

gcloud compute instances delete core-01 core-02 core-03  -q
