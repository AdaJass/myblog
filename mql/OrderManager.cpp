//+------------------------------------------------------------------+
//|                                                 OrderManager.mq4 |
//|                                                         Ada.Jass |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Ada.Jass"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
struct ORDER{
   string orderid;
   string pair;
   double lots;
   bool direction;
   string type;
   double uppending; 
   double downpending;  
   int maxstoploss;
   double tolerancestoploss;
   int tolerancestoptime;
   double maxprofit;
   double conservativeprofit;   
   int orderlasttime;
   double previousordertime;
   double equitywhenstart;
   double previousorderid;
   double conservativetime;
};
ORDER Orders[30];
ORDER PreOrders[30];
int PreOrdersLen=0;
int OrdersLen=0;

string GetWebString(const string url){
   int    res;     // To receive the operation execution result 
   char   data[];  // Data array to send POST requests 
   char result[];
   string result_head;
   res = WebRequest( 
      "GET",           // HTTP method 
      url,              // URL 
      NULL,          // headers  
      5000,          // timeout 
      data,          // the array of the HTTP message body 
      result,        // an array containing server response data 
      result_head   // headers of server response 
    );
    Print("response code: ", res);
    return CharArrayToString(result);
}

void FillOrdersFromWebSever(){
    string webstring = GetWebString("http://127.0.0.1/showorderstring";
    ushort u_sep;                  // The code of the separator character 
    string result[];               // An array to get strings 
    //--- Get the separator code 
    u_sep=StringGetCharacter("|",0);     
    //--- Split the string to substrings 
    int k=StringSplit(webstring,u_sep,result); 
    if(k>0) 
    { 
        string tempres=[];
        for(int i=0;i<k;i++) 
        { 
            tempres=[];
            StringSplit(result[i],StringGetCharacter(",",0),tempres);  //            
            Orders[i].orderid=tempres[0];
            Orders[i].pair=tempres[1];
            Orders[i].lots=tempres[2];
            Orders[i].direction=tempres[3];
            Orders[i].type=tempres[4];
            Orders[i].uppending=tempres[5]; 
            Orders[i].downpending=tempres[6];  
            Orders[i].maxstoploss=tempres[7];
            Orders[i].tolerancestoploss=tempres[8];
            Orders[i].tolerancestoptime=tempres[9];
            Orders[i].maxprofit=tempres[10];
            Orders[i].conservativeprofit=tempres[11];   
            Orders[i].orderlasttime=tempres[12];
            Orders[i].previousordertime=tempres[13];
            Orders[i].equitywhenstart=tempres[14];
            Orders[i].previousorderid=tempres[15];
            Orders[i].conservativetime=tempres[16];
        } 
        OrdersLen = k;
    }

}

int OnInit(){

   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason){

   EventKillTimer();
      
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
//---
    for(int i=0;i<PreOrdersLen;i++){
        for(int j=0;j<OrdersTotal();j++){
            if(OrderSelect(j,SELECT_BY_POS)==true&&OrderMagicNumber()==PreOrders[i].orderid){
                //here modify the order
                //if stop the order, should make a order info send to server.
            } 
        }
    }
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
//---
    FillOrdersFromWebSever();
    bool isshow=false;
    for(int ii=0;ii<OrdersLen;ii++){
        isshow=false;
        for(int jj=0;jj<PreOrdersLen;jj++){
            if(Orders[ii].orderid==PreOrders[jj].orderid){
                isshow=true;
            }
        }
        if(!isshow){
            //deal here
        }
    }
    for(int ii=0;ii<PreOrdersLen;ii++){
        isshow=false;
        for(int jj=0;jj<OrdersLen;jj++){
            if(Orders[jj].orderid==PreOrders[ii].orderid){
                isshow=true;
            }
        }
        if(!isshow){
            //stop deal here
        }
    }
    PreOrders=Orders;
    PreOrdersLen=OrdersLen;
}
//+------------------------------------------------------------------+
