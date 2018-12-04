//+------------------------------------------------------------------+
//|                                                  CandleShape.mqh |
//|                                                         Ada.Jass |
//|                                                  jass.ada@qq.com |
//+------------------------------------------------------------------+
#ifndef __CANDLE_SHAPE_
#define __CANDLE_SHAPE_

#include "PublicStuff.mqh"

#property copyright "Ada.Jass"
#property link      "jass.ada@qq.com"
#property strict

double iBody(int shift)
{
   return ((iClose(NULL,0,shift)-iOpen(NULL,0,shift))/Point);
}
double iShadow(int shift)
{
   return (iHigh(NULL,0,shift)-iLow(NULL,0,shift))/Point-MathAbs(iBody(shift));
}

bool IsDoji(int shift)
{
   double body=MathAbs(iBody(shift));
   double shadow=iShadow(shift);
   if(body<=CANDLE_STANDARD*0.02&&shadow>=CANDLE_STANDARD*0.7)
      return true;
   else 
      return false;
}

bool IsMarubozu(int shift)
{
   double body=MathAbs(iBody(shift));
   double shadow=iShadow(shift);
   if(body>CANDLE_STANDARD*0.6&&shadow<body*0.02)
      return true;
   else 
      return false;       
}


bool IsHanmmer(int shift)
{
   double body=iBody(shift);
   double upShadow=body>0?(iHigh(NULL,0,shift)-iClose(NULL,0,shift)/Point):(iOpen(NULL,0,shift)-iLow(NULL,0,shift)/Point);
   double downShadow=body<0?(iHigh(NULL,0,shift)-iOpen(NULL,0,shift)/Point):(iClose(NULL,0,shift)-iLow(NULL,0,shift)/Point);
   body=MathAbs(body);
   if(body+upShadow+downShadow>CANDLE_STANDARD&&body>=CANDLE_STANDARD*0.02&&((upShadow>(body+downShadow)*2)||(downShadow>(body+upShadow)*2)))
   {
      return true;
   }else
   {
      return false;
   }
}
bool IsBullishEngulfing(int shift)
{
   double preBody=iBody(shift+1);
   //double preShadow=iShadow(shift+1);
   double body=iBody(shift);
   double shadow=iShadow(shift);
   if(body>0&&body>shadow*2&&body>CANDLE_STANDARD*0.5&&preBody<0&&body+preBody>Point)
   {
      return true;
   }else{
      return false;
   }
}

bool IsBearishEngulfing(int shift)
{
   double preBody=-iBody(shift+1);
   //double preShadow=iShadow(shift+1);
   double body=-iBody(shift);
   double shadow=iShadow(shift);
   if(body>0&&body>shadow*2&&body>CANDLE_STANDARD*0.5&&preBody<0&&body+preBody>Point)
   {
      return true;
   }else{
      return false;
   }
}

bool IsTweezerBottom(int shift)  //must occur in downtrend
{
   double body0=iBody(shift);   
   double downShadow0=body0<0?(iHigh(NULL,0,shift)-iOpen(NULL,0,shift)/Point):(iClose(NULL,0,shift)-iLow(NULL,0,shift)/Point);
   double body1=iBody(shift+1);   
   double downShadow1=body1<0?(iHigh(NULL,0,shift+1)-iOpen(NULL,0,shift+1)/Point):(iClose(NULL,0,shift+1)-iLow(NULL,0,shift+1)/Point);
   
   if((iOpen(NULL,0,shift+4)-iClose(NULL,0,shift))/Point>CANDLE_STANDARD*3&&downShadow0>MathAbs(body0*1.5)&&
      downShadow1>MathAbs(body1*1.5)&&MathAbs(iLow(NULL,0,shift)-iLow(NULL,0,shift+1))/Point<3)
   {
      return true;
   }else{
      return false;
   }
   
}

bool IsTweezerTop(int shift)  //must occur in uptrend
{
   double body0=iBody(shift);   
   double upShadow0=body0>0?(iHigh(NULL,0,shift)-iClose(NULL,0,shift)/Point):(iOpen(NULL,0,shift)-iLow(NULL,0,shift)/Point);
   double body1=iBody(shift+1);   
   double upShadow1=body1>0?(iHigh(NULL,0,shift+1)-iClose(NULL,0,shift+1)/Point):(iOpen(NULL,0,shift+1)-iLow(NULL,0,shift+1)/Point);
   
   if((iOpen(NULL,0,shift)-iClose(NULL,0,shift+4))/Point>CANDLE_STANDARD*3&&upShadow0>MathAbs(body0*1.5)&&
      upShadow1>MathAbs(body1*1.5)&&MathAbs(iHigh(NULL,0,shift)-iHigh(NULL,0,shift+1))/Point<3)
   {
      return true;
   }else{
      return false;
   }   
}

bool IsMorningStar(int shift)
{
   double body2=iBody(shift+2);
   double body1=iBody(shift+1);
   double body0=iBody(shift);
   double shadow2=iShadow(shift+2);
   double shadow0=iShadow(shift);
   if(body2<-CANDLE_STANDARD*1.5&&MathAbs(body1)<CANDLE_STANDARD*0.15&&body0>CANDLE_STANDARD*0.6&&MathAbs(body2)>shadow2*4&&body0>shadow0*4)
   {
      return true;
   }else
   {
      return false;
   }
}

bool IsDuskStar(int shift)
{
   double body2=iBody(shift+2);
   double body1=iBody(shift+1);
   double body0=iBody(shift);
   double shadow2=iShadow(shift+2);
   double shadow0=iShadow(shift);
   if(body2>CANDLE_STANDARD*1.5&&MathAbs(body1)<CANDLE_STANDARD*0.15&&body0<-CANDLE_STANDARD*0.6&&body2>shadow2*4&&MathAbs(body0)>shadow0*4)
   {
      return true;
   }else
   {
      return false;
   }
}

bool IsThreeWhite(int shift)
{
   double body2=iBody(shift+2);
   if(body2<0||(iHigh(NULL,0,shift+2)-iClose(NULL,0,shift+2))/Point>body2*0.3)
      return false;  
   double body1=iBody(shift+1);
   if(body1<0||(iHigh(NULL,0,shift+1)-iClose(NULL,0,shift+1))/Point>body1*0.3)
      return false;  
   double body0=iBody(shift);
   if(body0<0||(iHigh(NULL,0,shift)-iClose(NULL,0,shift))/Point>body0*0.3)
      return false;
   if(body0+body1+body2>CANDLE_STANDARD*2)
      return true;
   else
      return false;
}
bool IsThreeDark(int shift)
{
   double body2=iBody(shift+2);
   if(body2>0||(iLow(NULL,0,shift+2)-iClose(NULL,0,shift+2))/Point<body2*0.3)
      return false;  
   double body1=iBody(shift+1);
   if(body1>0||(iLow(NULL,0,shift+1)-iClose(NULL,0,shift+1))/Point<body1*0.3)
      return false;  
   double body0=iBody(shift);
   if(body0<0||(iLow(NULL,0,shift)-iClose(NULL,0,shift))/Point<body0*0.3)
      return false;
   if(body0+body1+body2<-CANDLE_STANDARD*2)
      return true;
   else
      return false;
}

bool IsTwoEatOne(int shift)
{
   double body2=iBody(shift+2);
   double body1=iBody(shift+1);
   double body0=iBody(shift);
   if(body2*body1<0&&body1*body0>0&&MathAbs(body2)>CANDLE_STANDARD*1.5&&MathAbs(body1)*2>MathAbs(body2)&&
      MathAbs(body1)<MathAbs(body2)&&MathAbs(body0+body1)>MathAbs(body2))
   {
      return true;
   }else{
      return false;
   }
}

struct CURVE
{
   double correlation;  //the correlation coefficient of the first-order derivative
   double gradient;
};

CURVE Para_Curve(int shift) 
{ 
   double up[5],down[5];
   double close=0.0,open=0.0;
   for(int i=0;i<5;i++)
   {
      close=iClose(NULL,0,shift+i);
      open=iOpen(NULL,0,shift+i);
      if(close>=open)
      {
         up[i]=close;
         down[i]=open;
      }else{
         up[i]=open;
         down[i]=close;
      }      
   }
   double dataup[4];
   double datadown[4];
   for(int i=0;i<4;i++)
   {
      dataup[i]=up[i]-up[i+1];
      datadown[i]=down[i]-down[i+1];
   }
   double c_up=_Relative(dataup);
   double c_down=_Relative(datadown);
   double gradiant;
   CURVE curve; 
   if(MathAbs(c_up)>MathAbs(c_down))
   {
      curve.correlation=c_up;
      curve.gradient=_Regression(dataup);
   }else{
      curve.correlation=c_down;
      curve.gradient=_Regression(datadown);
   }
     
   return curve;
}

bool IsTriangle(int start_index, int count)
{
   double up[],down[];
   ArrayResize(down,count,10);
   ArrayResize(up,count,10);
   double close=0.0,open=0.0;
   for(int i=0;i<count;i++)
   {
      close=iClose(NULL,0,start_index+i);
      open=iOpen(NULL,0,start_index+i);
      if(close>=open)
      {
         up[i]=close;
         down[i]=open;
      }else{
         up[i]=open;
         down[i]=close;
      }      
   }
   double dataup[];
   double datadown[];
   ArrayResize(datadown,count);
   ArrayResize(dataup,count);
   for(int i=0;i<count-1;i++)
   {
      dataup[i]=up[i]-up[i+1];
      datadown[i]=down[i]-down[i+1];
   }
   double c_up=_Relative(dataup);
   double c_down=_Relative(datadown);
   if(MathAbs(c_up)<0.8&&MathAbs(c_down)<0.8)
      return false;
   
   double sum=0.0;
   double aver=0.0;
   for(int i=0;i<count;i++)
   {
      sum+=MathAbs(iBody(i+start_index));
      if(i%3==2){
         if(sum/(i+1)<aver){
            return false;
         }else{
            aver=sum/(i+1);
         }
      }
   }
   return true;
}


#endif  