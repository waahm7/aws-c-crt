#!/usr/bin/env python3
import argparse
from dataclasses import dataclass
import os
import os.path
import re
import subprocess

ROOT_DIR = os.path.abspath(os.path.dirname(__file__))


@dataclass
class Repo:
    path: str
    name: str
    url: str


def all_repos():
    """Read .gitmodules and return Repo list"""
    start_pattern = re.compile(r'\[submodule')
    path_pattern = re.compile(r'\s+path = (\S+)')
    url_pattern = re.compile(r'\s+url = (\S+)')

    repos = []
    current = None
    with open(os.path.join(ROOT_DIR, '.gitmodules'), 'r') as f:
        for line in f.readlines():
            m = start_pattern.match(line)
            if m:
                current = Repo("", "", "")
                repos.append(current)
                continue

            m = path_pattern.match(line)
            if m:
                current.path = m.group(1)
                current.name = os.path.basename(current.path)
                continue

            m = url_pattern.match(line)
            if m:
                current.url = m.group(1)
                continue

    return repos


def repo_name_matches(repo, s):
    return s and (repo.name == s or repo.name.endswith(f'-{s}'))


def find_repo_idx(repos, s):
    try:
        return next(i for i, v in enumerate(repos) if repo_name_matches(v, s))
    except StopIteration:
        exit(f'repo "{s}" not found, or already filtered out')


def filter_repos(repos, start_at="", stop_before="", stop_after=""):
    if args.start_at:
        idx = find_repo_idx(repos, args.start_at)
        repos = repos[idx:]

    if args.stop_before:
        idx = find_repo_idx(repos, args.stop_before)
        repos = repos[:idx]

    if args.stop_after:
        idx = find_repo_idx(repos, args.stop_after)
        repos = repos[:idx + 1]

    return repos


def check_call(args):
    print('$', subprocess.list2cmdline(args))
    subprocess.check_call(args)


def check_output(args):
    print('$', subprocess.list2cmdline(args))
    output = subprocess.check_output(args)
    try:
        return output.decode()
    except UnicodeDecodeError:
        pass
    return output


def sync_repo(repo, branch):
    print(f'--- {repo.name} ---')

    os.chdir(os.path.join(ROOT_DIR, repo.path))

    porcelain = check_output(['git', 'status', '--porcelain'])
    if porcelain:
        exit(f'{repo.name} not clean:\n{porcelain}')

    check_call(['git', 'fetch'])

    try:
        check_call(['git', 'checkout', branch])
    except Exception as e:
        if branch == 'main':
            raise e
        check_call(['git', 'checkout', 'main'])

    check_call(['git', 'pull'])

    os.chdir(ROOT_DIR)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Git checkout and pull latest on all repos")
    parser.add_argument('--branch', default='main', help='checkout this branch (default: main)')
    parser.add_argument('--start-at', help='start at this repo')
    parser.add_argument('--stop-before', help='stop before this repo')
    parser.add_argument('--stop-after', help='stop after this repo')
    args = parser.parse_args()

    repos = all_repos()
    repos = filter_repos(repos, args.start_at, args.stop_before, args.stop_after)
    for repo in repos:
        sync_repo(repo, args.branch)
