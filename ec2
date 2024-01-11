#!/usr/bin/env python3
import argparse
from dataclasses import dataclass
import subprocess
import json
import os.path
import re
import sys

@dataclass
class Instance:
    nickname: str
    id: str
    region: str
    user = 'waqarak'

INSTANCES = [
    Instance('cd', 'dev-dsk-waqarak-2b-357399d6.us-west-2.amazon.com', 'us-west-2b'),
    Instance('ubuntu', 'i-0f2896bba20024a86', 'us-west-2'),
]

ARG_PARSER = argparse.ArgumentParser(prog='ec2', description='Start/Stop my EC2 instance')
ARG_PARSER.add_argument('action', choices=['start', 'stop'])
ARG_PARSER.add_argument('nickname', choices=[i.nickname for i in INSTANCES])


def run(cmd_args: list[str]):
    print(f'> {subprocess.list2cmdline(cmd_args)}')
    result = subprocess.run(cmd_args, capture_output=True, text=True)
    if result.returncode != 0:
        if result.stdout:
            print(result.stdout, end='')
        if result.stderr:
            print(result.stderr, end='', file=sys.stderr)
        exit(f'FAILED: {subprocess.list2cmdline(cmd_args)}')
    return result.stdout


def update_ssh_config(nickname, hostname):
    """
    Update lines that look like:

    Host ec2-dev
      HostName ec2-35-88-212-32.us-west-2.compute.amazonaws.com
    """
    config_path = os.path.expanduser('~/.ssh/config')

    with open(config_path, 'r') as f:
        lines = f.readlines()

    host = ''
    replaced_hostname = False
    for i, line in enumerate(lines):
        host_match = re.search(r'^Host +(\S+)', line, re.IGNORECASE)
        if host_match:
            host = host_match.group(1)
            continue

        if host == nickname:
            hostname_match = re.search('^( +HostName +)', line, re.IGNORECASE)
            if hostname_match:
                lines[i] = hostname_match.group(1) + hostname + '\n'
                replaced_hostname = True
                break

    if replaced_hostname:
        with open(config_path, 'w') as f:
            f.writelines(lines)
        print(f'Updated: {config_path}')
    else:
        exit(f'Failed to update "Host {nickname}" in: {config_path}')


def start(instance: Instance):
    run(['aws', 'ec2', 'start-instances', '--instance-ids', instance.id, '--profile', instance.user,'--region', instance.region])
    run(['aws', 'ec2', 'wait', 'instance-running', '--instance-ids', instance.id, '--profile', instance.user,'--region', instance.region])

    description = run(['aws', 'ec2', 'describe-instances', '--instance-ids', instance.id, '--profile', instance.user,'--region', instance.region])
    description = json.loads(description)
    hostname = description['Reservations'][0]['Instances'][0]['PublicDnsName']

    update_ssh_config(instance.nickname, hostname)


def stop(instance):
    run(['aws', 'ec2', 'stop-instances', '--instance-ids', instance.id, '--profile', instance.user, '--region', instance.region])
    run(['aws', 'ec2', 'wait', 'instance-stopped', '--instance-ids', instance.id, '--profile', instance.user, '--region', instance.region])


if __name__ == '__main__':
    args = ARG_PARSER.parse_args()
    instance = next(i for i in INSTANCES if i.nickname == args.nickname)
    if args.action == 'start':
        start(instance)
    else:
        stop(instance)
