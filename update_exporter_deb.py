from datetime import date
import argparse
import socket
from prometheus_client import CollectorRegistry, Gauge, push_to_gateway


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

    with open('/var/log/dpkg.log', 'r') as f:
        lines = f.readlines()

        today = date.today()

        installed = list(
            filter(lambda x: "upgrade" in x and today.strftime("%Y-%m-%d") in x, lines))

        registry = CollectorRegistry()
        g = Gauge('suc_package_upgraded', 'Information about upgraded package', [
                  'package', 'version', 'type', 'instance'], registry=registry)

        count = 0
        for line in installed:
            splitted_line = line.split(' ')
            package = splitted_line[3]
            version = splitted_line[5].strip()
            g.labels(package, version, 'apt', socket.getfqdn()).set(1)
            push_to_gateway(args.url, job='suc', registry=registry)


if __name__ == "__main__":
    main()
