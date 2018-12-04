//+------------------------------------------------------------------+
//|                                               odersoperation.mqh |
//|                                                         Ada.Jass |
//|                                                  jass.ada@qq.com |
//+------------------------------------------------------------------+
#property copyright "Ada.Jass"
#property link      "jass.ada@qq.com"
#property strict
/*
以下所有函数都只针对当前货币对，要想对所有货币对只需稍作修改。
为方便大家使用我已经添加了中文注释，本程序可以随意传播，但后果自负。
*/
int scale=int(MathCeil(1/Point));

void CloseAllGainOrders(int profitPoints)  //关掉本货币兑下所有利润大于profitPoints个点数的定单
{
   for(int ii=0,all=OrdersTotal();ii<all;ii++){               
      if(!OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
         continue;
                  
      if(OrderSymbol()!=Symbol())
         continue; 
                
      RefreshRates();
      if(OrderType()==OP_BUY&&scale*(Ask-OrderOpenPrice())>profitPoints){ 
         if(OrderClose(OrderTicket(),OrderLots(),Bid,10,clrRed)){            
            ii-=1;
            continue;
         }
      }
      if(OrderType()==OP_SELL&&scale*(OrderOpenPrice()-Bid)>profitPoints){
         if(OrderClose(OrderTicket(),OrderLots(),Ask,10,clrRed)){         
            ii-=1;
         }
      }
   } 
}

int HedgeAllOrders()  
{ 
   //本函数将当前货币对下的所有订单对冲掉，也就是锁仓，利润和亏损不再拉大，
   //返回对冲单的定单号
   double orderLot=0.0;
   
   for(int ii=0,all=OrdersTotal();ii<all;ii++){               
      if(!OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
         continue;
         
      if(OrderSymbol()!=Symbol())
         continue;
         
      if(OrderType()==OP_BUY){        
         orderLot+=OrderLots();
      }                                        
      if(OrderType()==OP_SELL){
         orderLot-=OrderLots();
      }                 
   }
   int ticket=0;
   RefreshRates();
   if(orderLot>0.01)
   {
      ticket=OrderSend(Symbol(),OP_SELL,orderLot,Bid,3,0,0,NULL,0,0,clrGreen);
   }
   if(orderLot<-0.01)
   {
      ticket=OrderSend(Symbol(),OP_BUY,MathAbs(orderLot),Ask,3,0,0,NULL,0,0,clrGreen);
   }
   return ticket;
}

void _CloseAllOrders()  //关掉所有当前货币的定单，包括挂单。
{
   for(int cnt=0;cnt<OrdersTotal();)
   {
      if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES))
         continue;
         
      if(OrderSymbol()!=Symbol())
         continue;            
      RefreshRates();     
      if(OrderType()==OP_BUY)
      {
         if(!OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),3,Violet))
            Print("OrderClose error ",GetLastError());
         continue;
      }
      
      RefreshRates();       
      if(OrderType()==OP_SELL)
      {
         if(!OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),3,Violet))
            Print("OrderClose error ",GetLastError()); 
         continue;        
      }
      
      if(OrderType()>=2)
         if(!OrderDelete(OrderTicket()))
            Print("OrderClose error ",GetLastError());
   }
}


void SetProfit(double pips)
{
   for(int ii=0,all=OrdersTotal();ii<all;ii++){               
      if(!OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
         continue;
         
      if(OrderSymbol()!=Symbol())
         continue;            
       
      if(OrderType()%2==0&&OrderTakeProfit()<0.00001){    //the buy type      
         OrderModify(OrderTicket(),OrderOpenPrice(),0,OrderOpenPrice()+pips*Point,0,clrYellow);         
      }                                        
      if(OrderType()%2==1&&OrderTakeProfit()<0.00001){    //the sell type
         OrderModify(OrderTicket(),OrderOpenPrice(),0,OrderOpenPrice()-pips*Point,0,clrYellow);       
      }                 
   }
}

void RemoveProfit()
{
   for(int ii=0,all=OrdersTotal();ii<all;ii++){               
      if(!OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
         continue;
         
      if(OrderSymbol()!=Symbol())
         continue;            
       
      if(OrderType()%2==0&&OrderTakeProfit()>0.00001){    //the buy type      
         OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),0,0,clrYellow);         
      }                                        
      if(OrderType()%2==1&&OrderTakeProfit()>0.00001){    //the sell type
         OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),0,0,clrYellow);       
      }                 
   }
}


void SetStopLoss(double pips)
{
   for(int ii=0,all=OrdersTotal();ii<all;ii++){               
      if(!OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
         continue;
         
      if(OrderSymbol()!=Symbol())
         continue;            
       
      if(OrderType()%2==0&&Bid-pips*Point>OrderStopLoss()){    //the buy type      
         OrderModify(OrderTicket(),OrderOpenPrice(),Bid-pips*Point,0,0,clrYellow);         
      }                                        
      if(OrderType()%2==1&&Bid-pips*Point<OrderStopLoss()){    //the sell type
         OrderModify(OrderTicket(),OrderOpenPrice(),Bid+pips*Point,0,0,clrYellow);       
      }                 
   }
}

void RemoveStopLoss()
{
   for(int ii=0,all=OrdersTotal();ii<all;ii++){               
      if(!OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
         continue;
         
      if(OrderSymbol()!=Symbol())
         continue;            
       
      if(OrderType()%2==0&&OrderTakeProfit()>0.00001){    //the buy type      
         OrderModify(OrderTicket(),OrderOpenPrice(),0,OrderTakeProfit(),0,clrYellow);         
      }                                        
      if(OrderType()%2==1&&OrderTakeProfit()>0.00001){    //the sell type
         OrderModify(OrderTicket(),OrderOpenPrice(),0,OrderTakeProfit(),0,clrYellow);       
      }                 
   }
}

double OrdersStatistics()
{
   double orderLot=0.0;
   
   for(int ii=0,all=OrdersTotal();ii<all;ii++){               
      if(!OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
         continue;
         
      if(OrderSymbol()!=Symbol())
         continue;
         
      if(OrderType()==OP_BUY){        
         orderLot+=OrderLots();
      }                                        
      if(OrderType()==OP_SELL){
         orderLot-=OrderLots();
      }                 
   }
   return orderLot;      
} 