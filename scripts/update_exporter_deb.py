from datetime import date
import argparse
import socket
from prometheus_client import CollectorRegistry, Gauge, pushadd_to_gateway, instance_ip_grouping_key


def main():
    """ Read what packages were updated today
    reads the contents of /var/log/dpkg.log, parses it and pushes the
    information to a prometheus push gateway.
    """
    parser = argparse.ArgumentParser(
        description='Send updated packages to prometheus push gateway.')
    parser.add_argument('url', metavar='URL', type=str, default='', nargs='?',
                        help='url for prometheus push gateway')

    args = parser.parse_args()

    if args.url == '':
        print('No push gateway url given, skipping...')
        exit()

    registry = CollectorRegistry()

    g = Gauge('suc_package_upgraded', 'Information about upgraded package', [
        'package', 'version', 'type'], registry=registry)

    with open('/var/log/dpkg.log', 'r') as f:
        today = date.today().strftime("%Y-%m-%d")

        for line in f:
            if 'upgrade' in line and today in line:
                splitted_line = line.split(' ')
                package = splitted_line[3]
                version = splitted_line[5].strip()
                g.labels(package, version, 'apt').set(1)

    pushadd_to_gateway(args.url, job='suc', registry=registry,
                       grouping_key={'instance': socket.gethostname()})


if __name__ == "__main__":
    main()
