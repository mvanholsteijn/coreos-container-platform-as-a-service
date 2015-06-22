all: user-data user-data.json

user-data: preamble consul-http-router.service consul-server-registrator.service consul-server.service
	@( 	cat preamble ;  \
		for f in *.service ; do   echo "    - name: $$(basename $$f)" ; echo "      command: start"; echo "      content: |" ; \
		sed -e '/Global=true/d' -e 's/^/        /' $$f ; done  ) > $@ 
	@echo $@ updated.

user-data.json: user-data
	@( echo '{'; \
		echo '"Fn::Base64": {' ; \
		echo '"Fn::Join": [ "", [' ; \
		cat user-data |  \
		sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/^/        "/' -e 's/$$/\\n",/' | \
		sed -e 's/discovery: to-be-generated/discovery: ", {"Ref": "DiscoveryURL"}, "/' ;  \
		echo '"" ]]}}' ) > $@
	@echo $@ updated.

clean: 
	-rm -rf user-data user-data.json
