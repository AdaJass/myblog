//+------------------------------------------------------------------+
//|                                                   FlatMarket.mqh |
//|                                                         Ada.Jass |
//|                                                  jass.ada@qq.com |
//+------------------------------------------------------------------+
#ifndef __FLATMARKET__
#define __FLATMARKET__

#include "PublicStuff.mqh"

#property copyright "Ada.Jass"
#property link      "jass.ada@qq.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+

double Distance_Aver(int start_index, int count,int period=2)
{
   double distance=0.0;  
   double temDis=0.0; 
   for(int i=start_index,l=start_index+count;i<l;i=i+2)
   {
      distance+=MathAbs(iClose(NULL,0,i)+iClose(NULL,0,i+1)-iOpen(NULL,0,i)-iOpen(NULL,0,i+1))/Point;
   }
   if(count%2==1)
      count=count-1;
   return distance/count;
}



double Regression(int start_index,const int count)
{
   double data[];
   ArrayResize(data,count,10);
   double lowest=iLowest(NULL,0,MODE_CLOSE,count,start_index);
   double tem=0.0,sum=0.0;  
   for(int i=0;i<count;i++)
   {
      tem=(iClose(NULL,0,i+start_index)-lowest)/Point;
      data[i]=tem;
      sum+=tem;
   }
   double aver_X=(count-1)/2;
   double aver_Y=sum/count;
   double numerator=0.0,denominator=0.0;
   for(int i=0;i<count;i++)
   {
      numerator+=(i-aver_X)*(data[i]-aver_Y);
      denominator+=(i-aver_X)*(i-aver_X);
   }
   return numerator/denominator;
}


double Relative(int start_index, int count)
{
   double data[];
   ArrayResize(data,count,10);
   int low=iLowest(NULL,0,MODE_CLOSE,count,start_index);
   double lowest=iClose(NULL,0,low);
   double tem=0.0,sum=0.0;  
   for(int i=0;i<count;i++)
   {
      tem=(iClose(NULL,0,i+start_index)-lowest)/Point;
      data[i]=tem;
      sum+=tem;
   }
   double aver_X=(count-1)/2;
   double aver_Y=sum/count;
   double numerator=0.0,denominator1=0.0,denominator2=0.0;
   for(int i=0;i<count;i++)
   {
      numerator+=(i-aver_X)*(data[i]-aver_Y);
      denominator1+=(i-aver_X)*(i-aver_X);
      denominator2+=(data[i]-aver_Y)*(data[i]-aver_Y);
   }
   double denominator=MathSqrt(denominator1*denominator2)+0.0000000001;
   return numerator/denominator;
}

double MACD_Aver(int start_index,int count)  
{   
   double absum=0.0;
   for(int i=0;i<count;i++)
   {
      absum+=MathAbs(iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,start_index+i));           
   }
   
   return absum/count;
}

double RectangleHigh(int start_index,int count)
{
   double highest=iHighest(NULL,0,MODE_CLOSE,count,start_index);
   double lowest=iLowest(NULL,0,MODE_CLOSE,count,start_index);
   double v=(iClose(NULL,0,highest)-iClose(NULL,0,lowest))/Point;
   return v;
}

double SumofAll(int start_index,int count)
{
   double sum=0.0;
   for(int i=0;i<count;i++)
   {
      sum+=(iClose(NULL,0,i+start_index)-iOpen(NULL,0,i+start_index))/Point;
   }
   return sum;
}


double Variance(int start_index, int count)
{
   double data[];
   ArrayResize(data,count,10);   
   double tem=0.0,sum=0.0;  
   for(int i=0;i<count;i++)
   {
      tem=MathAbs(iClose(NULL,0,i+start_index)-iOpen(NULL,0,i+start_index))/Point;
      data[i]=tem;
      sum+=tem;
   }
   double aver_X=sum/count;
   sum=0.0;
   for(int i=0;i<count;i++)
   {
      sum+=(data[i]-aver_X)*(data[i]-aver_X);
   }
   return sum/count;
}

int Longest(int start_index, int count)
{
   int max=start_index;
   double tem=0.0;
   for(int i=0;i<count;i++)
   {
      tem = MathAbs(iClose(NULL,0,i+start_index)-iOpen(NULL,0,i+start_index))/Point;
      if(MathAbs(iClose(NULL,0,max)-iOpen(NULL,0,max))/Point<tem)
         max=i+start_index;
   }
   return max;
}

bool IsRoughFlat(int start_index, int count)
{
   //if(Distance_Aver(start_index,count)>0.55*CANDLE_STANDARD)  //平均波动大小应该选取相对值而不是单一的孤立值
      //return false;
   if(MACD_Aver(start_index,count)>MACDNORMAL){       
      return false;
   }
   
   int index=Longest(start_index,count);
   if(MathAbs(iClose(NULL,0,index)-iOpen(NULL,0,index))/Point>2*CANDLE_STANDARD)
      return false;
      
   if(MathAbs(SumofAll(start_index,count))>3*CANDLE_STANDARD)
      return false;
   
   int k=3;
   for(int i=0;i<k;i++)
   {
      if(MathAbs(SumofAll(start_index+i*4,4))>3*CANDLE_STANDARD)
         return false;
   }
   
   //if(MathAbs(Relative(start_index,count))<0.6)
      //return false;
      
   //if(MathAbs(Regression(start_index,count))>6)
      //return false;
   if(RectangleHigh(start_index,count)>4*CANDLE_STANDARD)  //极大值
      return false;
   
   
   return true;
   
}

bool IsStrongFlat(int start_index, int count)
{
   if(RectangleHigh(start_index,count)>0.8*CANDLE_STANDARD)
      return false;
      
   if(SumofAll(start_index,count)>0.5*CANDLE_STANDARD)
      return false;
   
   return true;  
}

#endif  