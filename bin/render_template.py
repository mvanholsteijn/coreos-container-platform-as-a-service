import os
from jinja2 import Environment, FileSystemLoader
from optparse import OptionParser, Option

parser = OptionParser()
parser.add_option("-t", "--template", dest="template", default="./config/cloudformation.template.jinja",
                  help="the template file to load.", metavar="FILE")
parser.add_option("-w", "--with-test-instances",
                  action="store_true", dest="with_test_instances", default=False,
                  help="generate with test instances in availability zones")
parser.add_option("-e", "--use-http-protocol-on-elb",
                  action="store_true", dest="use_http_protocol_on_elb", default=False,
                  help="use HTTP protocol on ELB, instead of TCP")

(options, args) = parser.parse_args()
env = Environment(loader=FileSystemLoader(os.path.dirname(options.template)))
template = env.get_template(os.path.basename(options.template))
print template.render(options=options)
