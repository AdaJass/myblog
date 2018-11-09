from aiohttp import web
import aiohttp_jinja2
from aiohttp_jinja2 import jinja2
from datetime import datetime
from datetime import timedelta
from mongodb import *
"""
orderstruct = {   #json cell data deliver to mt4
    orderid: 112
    pair: EURUSD
    lots: 1.0
    direction: 1/-1
    type: pending
    uppending: 1.1115  #price upper will deal
    downpending: 1.1114   #price lower will deal
    maxstoploss: 20 Points
    tolerancestoploss: 1.1114
    tolerancestoptime: 2h
    maxprofit: 1.1123
    conservativeprofit: 1.1123   #when the profit up to a top level, profit drop down after the next four hour, it will be actived
    orderlasttime: 24h
    previousordertime: 
    equitywhenstart:
    previousorderid:
    conservativetime:
}

orderinfo={
    pair:
    type: pending/directing
    direction:
    price:
    orderopenprice:
    orderopentime:
    orderid:
}
"""
OrderList = []
LastDealTime = datetime.today()
ProfitDoubleTime = datetime.today()-timedelta(8)
EquityCutOffTime = datetime.today()-timedelta(8)
AccountEquity = 0.0
LastOrderId = 0

async def makeorder(request):
    para = await request.post()
    global OrderList
    orderstruct = dict(para) 
    orderstruct['previousordertime'] = datetime.strftime(LastDealTime,'%Y-%m-%d %H:%M:%S')
    orderstruct['equitywhenstart'] = AccountEquity
    orderstruct['previousorderid'] = LastOrderId
    pairlist=[]
    pairlist.append(orderstruct.get('pair'))
    for order in OrderList:
        if order.get('pair') not in pairlist:
            pairlist.append(order.get('pair'))
    if len(pairlist) > 2:
        return web.Response(text="too many intention! deal not allow!!!")
    timenow = datetime.today()
    if timenow - ProfitDoubleTime < timedelta(7) or timenow - ProfitDoubleTime < timedelta(7):
        return web.Response(text="your mood are not good enough to deal! please calm down several days!")
    orderstruct['orderid'] = len(OrderList)+1
    OrderList.append(orderstruct)
    print(orderstruct)
    print(para)
    return web.HTTPFound('/showorder')

async def deleteorder(request):
    para = await request.post()
    infoList = dict(para) 
    # for orderstruct in OrderList:


async def showorder(request):
    print('showorder')
    global orderstruct    
    if len(OrderList)>0:        
        return web.json_response(OrderList)
    else:
        return web.Response(text="no")
        pass

async def savecomment(request):
    para = await request.post()
    para = dict(para)
    db_comments.insert(para)
    print('yes')
    return web.Response(text="ok")


@aiohttp_jinja2.template('chat.jinja2')
async def chatpage(request):
    para = request.query
    data = {}
    if para.get('chapter'):
        data['chapter'] = para.get('chapter')
    return data

async def confirm_direct(request):
    para = await request.post()
    global orderstruct  
    if para.get('confirm'):
        orderstruct = {}
        return web.Response(text="ok")
    else:
        return web.Response(text="nok")
        pass
        
async def parse_chatcontent(request):
    para = request.query
    if para.get('s'):
        try:
            with open('./client'+para.get('s'),'r',encoding='utf-8') as f:
                ct = f.read()
                # kw1=para.get('kw1')
                # kw2=para.get('kw2')
                ct= ct.replace('\n\n','|||')
                ct = ct.replace('\n','')
            return web.Response(text=ct)
        except FileNotFoundError:
            return web.Response(text="章节不存在！")        
    else:
        return web.Response(text="None")
        pass

app = web.Application()
aiohttp_jinja2.setup(app,
    loader=jinja2.FileSystemLoader('./client'))
app.router.add_get('/showorder', showorder)
app.router.add_get('/chatcontent', parse_chatcontent)
app.router.add_get('/s/chat', chatpage) 

app.router.add_post('/makeorder', makeorder)
app.router.add_post('/savecomment', savecomment)
app.router.add_post('/confirm_direct', confirm_direct)

app.router.add_static('/s/', path='./client', name='static')
web.run_app(app)