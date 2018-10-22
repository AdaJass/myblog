from aiohttp import web
import aiohttp_jinja2
from aiohttp_jinja2 import jinja2

orderstruct={}
async def makeorder(request):
    para = await request.post()
    global orderstruct
    if orderstruct:
        return web.Response(text="nonononono!")
    orderstruct = dict(para)   
    print(orderstruct)
    print(para)
    return web.HTTPFound('/showorder')

async def showorder(request):
    print('showorder')
    global orderstruct    
    if orderstruct:        
        return web.json_response(orderstruct)
    else:
        return web.Response(text="nonononono!")
        pass

@aiohttp_jinja2.template('tmpl.jinja2')
async def handler(request):
    return {'name': 'Andrew', 'surname': 'Svetlov'}

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
        with open('./client'+para.get('s'),'r',encoding='utf-8') as f:
            ct = f.read()
            # kw1=para.get('kw1')
            # kw2=para.get('kw2')
            ct= ct.replace('\n\n','|||')
            ct = ct.replace('\n','')
        return web.Response(text=ct)
    else:
        return web.Response(text="None")
        pass

app = web.Application()
aiohttp_jinja2.setup(app,
    loader=jinja2.FileSystemLoader('/path/to/templates/folder'))
app.router.add_get('/showorder', showorder)
app.router.add_get('/chatcontent', parse_chatcontent)
app.router.add_get('/chat', chatpage)

app.router.add_post('/makeorder', makeorder)
app.router.add_post('/confirm_direct', confirm_direct)

app.router.add_static('/s/', path='./client', name='static')
web.run_app(app)