with open('./client/chatcontent/chat_1123.txt','r',encoding='utf-8') as f:
    ct = f.read()
    # kw1=para.get('kw1')
    # kw2=para.get('kw2')
    ct= ct.replace('\n\n','|')
    ct = ct.replace('\n','')
    ct = ct.replace('|','\n')
    print(ct)