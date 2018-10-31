import pymongo
from pymongo import MongoClient
__client = MongoClient('mongodb://localhost:27017')
valid_order =__client.myblog.valid_order

if __name__ == '__main__':
    valid_order.insert({'ss':{'sj':9}})
    print(list(valid_order.find({})))