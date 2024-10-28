import redis

cache = redis.Redis(host='localhost', port=4721)
print('Hello World! {}.\n'.format(cache.incr('hits')))
