import time
import logging
import os

from dotenv import load_dotenv
import redis
import redis.exceptions
import flask
from flask import Flask, request

logging.basicConfig(filename='/var/log/nginx/flaskapp.log',
                    filemode='a',
                    format='%(asctime)s %(name)s %(levelname)s %(message)s',
                    level=logging.DEBUG)

logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

load_dotenv()

app = Flask(__name__)
app.secret_key = os.getenv('SECRET_KEY')
cache = redis.Redis(host='redis', port=4721)


# init count_prog
cache.set('count_prog', 10000, nx=True)
cache.set('isup', 'yes', nx=True)

MAX_PROG_SIZE = 16*1024  # 16KB

@app.route('/countcheck324')
def hello():
    return '{0}'.format(cache.incr('hits'))

@app.route('/lastbackup324')
def lastbackup():
    ls = cache.lastsave()
    return str(ls)

@app.route('/isup')
def isup():
    logger.info('isup. ip: %s', get_ip())
    return cache.get('isup')

@app.route('/save_prog', methods=['POST'])
def save_prog():
    return allow_origin(flask.jsonify(_save_prog()))
def _save_prog():
    try:
        post_data = request.get_json()
        prog = post_data['prog']
    except Exception:
        return {'resp': 'error', 'error': 'invalid JSON'}
    if not isinstance(prog, str):
        return {'resp': 'error', 'error': 'prog must be a string'}
    if len(prog) > MAX_PROG_SIZE:
        return {'resp': 'error', 'error': 'prog too long'}
    metaprog = {
        'ts': int(time.time()),
        'ip': get_ip(),
        'sz': len(prog),
    }
    try:
        key = str(cache.incr('count_prog'))
        cache.set('prog:' + key, prog)
        cache.hmset('prog:' + key + ':meta', metaprog)
        return {'resp': 'success', 'key': key}
    except Exception as e:
        return {'resp': 'error', 'error': 'db connection error'}


@app.route('/get_prog', methods=['POST'])
def get_prog():
    return allow_origin(flask.jsonify(_get_prog()))
def _get_prog():
    try:
        post_data = request.get_json()
        key = post_data['key']
    except Exception:
        return {'resp': 'error', 'error': 'invalid JSON'}
    try:
        int(key)
    except Exception:
        return {'resp': 'error', 'error': 'key must be an integer'}
    prog = cache.get('prog:' + str(key))
    if not isinstance(prog, bytes):
        return {'resp': 'error', 'error': 'key not found'}
    prog = prog.decode('utf-8')
    if prog:
        return {'resp': 'success', 'prog': prog}
    else:
        return {'resp': 'error', 'error': 'key not found'}

def allow_origin(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    return response

def get_ip():
    return request.access_route[-1]  # [-1] is the last X-Forwarded-For IP which is the client IP (set by Traefik)
    # if request.access_route:
    #     return request.access_route[-1]
    # else:
    #     return request.remote_addr
