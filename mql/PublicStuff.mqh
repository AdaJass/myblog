//+------------------------------------------------------------------+
//|                                                  PublicStuff.mqh |
//|                                                         Ada.Jass |
//|                                                  jass.ada@qq.com |
//+------------------------------------------------------------------+
#ifndef __PUBLICSTUFF__
#define __PUBLICSTUFF__

#property copyright "Ada.Jass"
#property link      "jass.ada@qq.com"
#property strict


double CANDLE_STANDARD=0.0;
double MACDNORMAL=0.0;

void calm_initialization(int star_index)
{   
   double macd[200];
   for(int i=0;i<200;i++){
      macd[i]=MathAbs(iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,i+star_index));  
      //Print(macd[i]);    
   }
   ArraySort(macd);
   double tem=0.0;
   for(int i=0;i<200;i++){
      tem+=macd[i];
   }
   tem=tem/200;   
   MACDNORMAL=tem;
   //Print("MACD NORMAL IS :",tem);
}

void initialization(int star_index)  //calculate the standard high of a candle.
{
   double sum=0;
   calm_initialization(star_index);
   for(int i=1;i<201;i++)
   {
      sum+=MathAbs((iClose(NULL,0,i+star_index)-iOpen(NULL,0,i+star_index))/Point);      
   }
   
   CANDLE_STANDARD=sum/200;
   //Print("The candle standard is: ",CANDLE_STANDARD);
}



double _Regression(double &data[],int count=0)  //return the gradient
{
   double pivot=data[0];
   double sum=0.0;
   if(count==0)
       count=ArraySize(data);  
   for(int i=0;i<count;i++)
   {      
      sum+=data[i];
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

double _Regression(double &datax[],double &datay[],int count=0)  //return the gradient
{
   
   double sumy=0.0,sumx=0.0;
   if(count==0)
       count=ArraySize(datax); 
   for(int i=0;i<count;i++)
   {      
      sumy+=datay[i];
      sumx+=datax[i];
      
   }
   double aver_X=sumx/count;
   double aver_Y=sumy/count;
   double numerator=0.0,denominator=0.0;
   for(int i=0;i<count;i++)
   {
      numerator+=(datax[i]-aver_X)*(datay[i]-aver_Y);
      denominator+=(datax[i]-aver_X)*(datax[i]-aver_X);
   }
   if(int(denominator)==0)
      return 0.0;
   return numerator/denominator;
}


double _Relative(double &data[], int count=0) //return the correlation coefficient
{
   double pivot=data[0];
   double sum=0.0; 
   if(count==0)
       count=ArraySize(data); 
   
   
   for(int i=0;i<count;i++)
   {      
      sum+=data[i];
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
   double denominator=MathSqrt(denominator1*denominator2);
   if(MathAbs(denominator)<0.0000001)
      denominator=0.00000001;
   return numerator/denominator;
}

#endif  