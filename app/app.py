import time
import logging

import redis
import redis.exceptions
from flask import Flask, request


app = Flask(__name__)
logger = logging.getLogger(__name__)

cache = redis.Redis(host='redis', port=4721)

# init prog_count
cache.setnx('prog_count', 10000)


@app.route('/')
def hello():
    return 'Hello World! {}.\n'.format(cache.incr('hits'))

@app.route('/lastbackup')
def lastbackup():
    ls = cache.lastsave()
    return 'Last backup: {}\n'.format(str(ls))

@app.route('/save_prog', methods=['POST'])
def save_prog():
    try:
        post_data = request.get_json()
        prog = post_data['prog']
    except Exception:
        return {'resp': 'error', 'error': 'invalid JSON'}
    try:
        key = cache.incr('prog_count')
        keyint = 'prog:' + str(key)
        cache.set(keyint, prog)
        return {'resp': 'success', 'key': key}
    except Exception as e:
        return {'resp': 'error', 'error': 'redis connection error'}


@app.route('/get_prog', methods=['POST'])
def get_prog():
    try:
        post_data = request.get_json()
        key = post_data['key']
    except Exception:
        return {'resp': 'error', 'error': 'invalid JSON'}
    try:
        int(key)
    except ValueError:
        return {'resp': 'error', 'error': 'key must be an integer'}
    prog = cache.get('prog:' + str(key))
    if not isinstance(prog, bytes):
        return {'resp': 'error', 'error': 'key not found'}
    prog = prog.decode('utf-8')
    if prog:
        return {'resp': 'success', 'prog': prog}
    else:
        return {'resp': 'error', 'error': 'key not found'}

