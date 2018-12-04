//+------------------------------------------------------------------+
//|                                                   CalmMarket.mqh |
//|                                                         Ada.Jass |
//|                                             shiyi.iloveu.forever |
//+------------------------------------------------------------------+
#ifndef __CALMMARKET__ 
#define __CALMMARKET__

#property copyright "Ada.Jass"
#property link      "jass.ada@qq.com"
#property strict

double MACDNORMAL=0.0;

struct CALM
{
   double macd_latest_aver;
   double macd_direction;
   int macd_length;
   int price_length;
   double ViborationWeaken;  //if>0 yes
   double highPrice;
   double gap;
   double lowPrice;
   int direction;
};

void calm_initialization()
{   
   double macd[400];
   for(int i=0;i<400;i++){
      macd[i]=MathAbs(iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,i));  
      //Print(macd[i]);    
   }
   ArraySort(macd);
   double tem=0.0;
   for(int i=100;i<300;i++){
      tem+=macd[i];
   }
   tem=tem/200;   
   MACDNORMAL=tem;
   //Print("MACD NORMAL IS :",tem);
}

bool MACDCalm(CALM &calm)  
{   
   double sum=0.0,absum=0.0;
   double sumarray[];
   ArrayResize(sumarray,400,300);
   int count=0;
   while(true){
      absum+=MathAbs(iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,count));
      sumarray[count]=absum; 
      sum+=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,count);
      count++;
      if(absum/count>MACDNORMAL*0.55||count>400){
         break;
      }
   }
   calm.macd_direction=sum/count;
   
   if(count>15)
   {
      int third=int(count/3);
      int two_third=int(count*0.6);
      double aver1=sumarray[third]/third;
      double aver2=sumarray[two_third]/two_third;
      double aver3=sumarray[count-1]/count;
      if(aver1<aver2&&aver1<aver3){
         calm.macd_latest_aver=aver1;
      }
      calm.macd_length=count;
      return true;      
   }  
   return false;
}

bool PriceCalm(CALM &calm)
{
   if(calm.macd_length<15)
   {  
      Print("there is an error in the use of PriceCale function ");
      return false;
   }
   
   int pivot=int(calm.macd_length/2);
   int high1=iHighest(NULL,0,MODE_CLOSE,pivot,pivot);   //left
   double hv1=iClose(NULL,0,high1);
   int high2=iHighest(NULL,0,MODE_CLOSE,pivot,0);
   double hv2=iClose(NULL,0,high2);
   
   int low1=iLowest(NULL,0,MODE_CLOSE,pivot,pivot);
   double lv1=iClose(NULL,0,low1);
   int low2=iLowest(NULL,0,MODE_CLOSE,pivot,0);
   double lv2=iClose(NULL,0,low2); 
   
   calm.highPrice=hv1>hv2?hv1:hv2;
   calm.lowPrice=lv1<lv2?lv1:lv2;
         
   double leftpoint = (hv1-lv1)/Point;
   double rightpoint = (hv2-lv2)/Point;
   
   double parallel = leftpoint-rightpoint;
   double slope_up=(hv1-hv2)/Point;
   double slope_down=(lv2-lv1)/Point;
   int direction=0;
   if(slope_down>0&&slope_up>0)
      direction=0;
   if(slope_down<0&&slope_up>0)
      direction=-1;
   if(slope_down>0&&slope_up<0)
      direction=1;      
   double scale=high1-high2<low1-low2?high1-high2:low1-low2;
     
   calm.ViborationWeaken=parallel;
   calm.direction=direction;
   calm.price_length=scale;  
   
   if(scale>15&&parallel>=-100)
      return true;
   else
      return false;   
}

#endif 
 