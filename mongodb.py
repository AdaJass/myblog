import pymongo
from pymongo import MongoClient
__client = MongoClient('mongodb://localhost:27017')

"""
{
    id:283
    data: 'djdkjgkd'
    father: the father's id
    chapter: 
    level: {
        1: comment to the page
        2:comment to comment        
    }
    atwho:
    time:
    author:
    head_pic:
    vote:
}
"""


db_valid_order =__client.myblog.valid_order
db_comments =__client.myblog.comments

if __name__ == '__main__':
    db_valid_order.insert({'ss':{'sj':9}})
    print(list(db_valid_order.find({},projection={'_id':False})))


