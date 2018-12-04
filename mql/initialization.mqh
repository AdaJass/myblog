//+------------------------------------------------------------------+
//|                                               initialization.mqh |
//|                                                         Ada.Jass |
//|                                                  jass.ada@qq.com |
//+------------------------------------------------------------------+
#property copyright "Ada.Jass"
#property link      "jass.ada@qq.com"
#property strict

enum TREND
{
   TrendGoesUp,
   TrendGoesDown,
   TrendGoesVibrate,
   TrendUnKnow
};


struct InitData
{
   int EAstat;
   double UpperBound;
   double LowerBound;
   double PendingUpperBound;
   double PendingLowerBound;
   double lastAutoBuyPrice;
   double lastAutoSellPrice;  
   int LockTicket;
   double InitLots;
   int InitUnitGap;
   double InitPrice;
   TREND EATrend;
   datetime LatestUpdate;
};
InitData EA;

InitData LoadData()
{
   int file_handle=FileOpen("Eternal//"+Symbol()+".ini",FILE_READ|FILE_BIN|FILE_COMMON);
   InitData  data={0,0,0,0,0,0,0,0,0,0,0,3,0};
   if(file_handle!=INVALID_HANDLE) 
   { 
      FileReadStruct(file_handle,data);
   }
   FileClose(file_handle);
   return data;

}

void SaveData(InitData &data)
{
   int file_handle=FileOpen("Eternal//"+Symbol()+".ini",FILE_READ|FILE_WRITE|FILE_BIN|FILE_COMMON); 
   if(file_handle!=INVALID_HANDLE) 
   {
      data.LatestUpdate=TimeCurrent();      
      FileWriteStruct(file_handle,data); 
   }
   FileClose(file_handle); 
}              