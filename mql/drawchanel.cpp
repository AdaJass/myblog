//+------------------------------------------------------------------+
//|                                                  DrawChannel.mq4 |
//|                                                         Ada.Jass |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Ada.Jass"
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
#include "../include/PublicStuff.mqh"

struct CUR
{
      int index;
      int shift;
      bool h_or_l;
      double coe;
};
struct LINE
{
      double tanh;
      double bbb;
      double dist_bbb;
      double dist_boundary_bbb;
      double day_return;
      double max_dropdown;
      int index;
      bool h_or_l;
      double risk_retrun;
};

int OnRegression(int num_arr, int num_min_arr, double coe_treshold, int shift_limit, int &search_list[], int search_l, CUR &usable_cur[])
{
      double high[100];
      double low[100];
      double cach_high[100];
      double cach_low[100];  
      double copy_cach[];    
      CUR all_rank[90000];
      int rank_iter = 0;
      // Print("len ",search_l);
      for (int num = 0; num < search_l; num++)
      {
            string sym = SymbolName(search_list[num],0);
            //Print(sym);
            if (iBars(sym, PERIOD_D1) < 12 || iTime(sym, PERIOD_D1, 0) < iTime("EURUSD", PERIOD_D1, 0))
                  continue;
            for (int i = 0; i < num_arr; i++)
            {
                  high[i] = iHigh(sym, PERIOD_D1, i + 1);
                  low[i] = iLow(sym, PERIOD_D1, i + 1);
            }
            for (int i = 0, all = num_arr - num_min_arr; i < all; i++)
            {
                  for (int j = 0; j < num_min_arr; j++)
                  {
                        cach_high[j] = high[i + j] / iClose(sym, PERIOD_D1, 1);
                        cach_low[j] = low[i + j] / iClose(sym, PERIOD_D1, 1);
                  }
                  ArrayCopy(copy_cach, cach_high,0,0,num_min_arr);
                  CUR tem;
                  tem.coe = MathAbs(_Relative(copy_cach));
                  tem.index = search_list[num];
                  tem.shift = i;
                  tem.h_or_l = True;                  
                  all_rank[rank_iter++]=tem;
                  
                  //---
                  ArrayCopy(copy_cach, cach_low,0,0,num_min_arr);
                  tem.coe = MathAbs(_Relative(copy_cach));
                  tem.index = search_list[num];
                  tem.shift = i + 1;
                  tem.h_or_l = FALSE;
                  all_rank[rank_iter++]=tem;
            }
      }

      int last_one=-1;
      int kkk = 0;
      for (int ii = 0; ii < rank_iter; ii++)
      {
            if (all_rank[ii].coe > coe_treshold)
            {
                  if (last_one == all_rank[ii].index)
                  {
                        if (kkk >= 1 && usable_cur[kkk - 1].index == all_rank[ii].index)
                              continue;
                        last_one = -1;
                        if (all_rank[ii].shift <= shift_limit){
                              usable_cur[kkk++] = all_rank[ii];                              
                        }
                  }
                  else
                  {
                        last_one = all_rank[ii].index;
                  }
            }
      }
      return kkk;
}

void CalCurve(int num_arr, int num_min_arr, CUR &usable_cur[],int uab_l, LINE &lines[])
{
      datetime starttime, endtime;
      int n, markplace;
      double pivot;
      double data_list[100];
      double time_list[100]; 
      double copy1[],copy2[];     
      for (int ii = 0; ii <uab_l; ii++)
      {
            // Print(SymbolName(usable_cur[ii].index,0));
            // Print(usable_cur[ii].index);
            // Print(usable_cur[ii].shift);
            // Print(usable_cur[ii].h_or_l);
            string symbol = SymbolName(usable_cur[ii].index,0);
            for (int i = 0; i < num_min_arr; i++)
            {
                  starttime = iTime(symbol, PERIOD_D1, i + 1);
                  endtime = iTime(symbol, PERIOD_D1, i);
                  n = (num_min_arr+1) * 12 * 24;
                  pivot = iClose(symbol, PERIOD_D1, i + 1);                  
                  while (n > 0)
                  {
                        if (iTime(symbol, PERIOD_M5, n) >= starttime && iTime(symbol, PERIOD_M5, n) < endtime)
                        {
                              if (usable_cur[ii].h_or_l == True)
                              {
                                    if (iHigh(symbol, PERIOD_M5, n) > pivot)
                                    {
                                          pivot = iHigh(symbol, PERIOD_M5, n);
                                          markplace = n;
                                    }
                              }
                              else
                              {
                                    if (iLow(symbol, PERIOD_M5, n) < pivot)
                                    {
                                          pivot = iLow(symbol, PERIOD_M5, n);
                                          markplace = n;
                                    }
                              }
                        }
                        n--;
                  }
                  data_list[i] = pivot;
                  time_list[i] = double(iTime(symbol, PERIOD_M5, markplace));
            }
            ArrayCopy(copy1, time_list,0,0,num_min_arr);
            ArrayCopy(copy2, data_list,0,0,num_min_arr);
            lines[ii].tanh = _Regression(copy1, copy2);
            lines[ii].bbb = data_list[0] - lines[ii].tanh * time_list[0];
            lines[ii].dist_bbb = lines[ii].bbb;            
            lines[ii].dist_boundary_bbb = lines[ii].bbb;
            ////////////////////////cal the dist_bbb and dist_boundary_bbb/////////////////////////
            for (int i = 0; i < num_min_arr; i++)
            {
                  starttime = iTime(symbol, PERIOD_D1, i + 1);
                  endtime = iTime(symbol, PERIOD_D1, i);
                  n = (num_min_arr+1) * 12 * 24;                  
                  while (n > 0)
                  {
                        if (iTime(symbol, PERIOD_M5, n) >= starttime && iTime(symbol, PERIOD_M5, n) < endtime)
                        {
                              if (usable_cur[ii].h_or_l == FALSE)
                              {
                                    // if(iLow(symbol, PERIOD_M5, n) < lines[ii].tanh *double(iTime(symbol, PERIOD_M5, n) + lines[ii].dist_boundary_bbb)){
                                    //       lines[ii].dist_boundary_bbb = iLow(symbol, PERIOD_M5, n) - lines[ii].tanh *double(iTime(symbol, PERIOD_M5, n));
                                    // }
                                    if (iHigh(symbol, PERIOD_M5, n) > pivot)
                                    {
                                          pivot = iHigh(symbol, PERIOD_M5, n);
                                          markplace = n;
                                    }
                              }
                              else
                              {
                                    // if(iHigh(symbol, PERIOD_M5, n) > lines[ii].tanh *double(iTime(symbol, PERIOD_M5, n) + lines[ii].dist_boundary_bbb)){
                                    //       lines[ii].dist_boundary_bbb = iHigh(symbol, PERIOD_M5, n) - lines[ii].tanh *double(iTime(symbol, PERIOD_M5, n));
                                    // }
                                    if (iLow(symbol, PERIOD_M5, n) < pivot)
                                    {
                                          pivot = iLow(symbol, PERIOD_M5, n);
                                          markplace = n;
                                    }
                              }
                        }
                        n--;
                  }

                  double tem_b = pivot - lines[ii].tanh *double(iTime(symbol, PERIOD_M5, markplace));
                  if(usable_cur[ii].h_or_l){
                        if(data_list[i] > lines[ii].dist_boundary_bbb + lines[ii].tanh * time_list[i]){
                              lines[ii].dist_boundary_bbb = data_list[i] - lines[ii].tanh * time_list[i];
                        }
                        if(tem_b < lines[ii].dist_bbb){
                              lines[ii].dist_bbb = tem_b;
                        }
                  }else{
                        if(data_list[i] < lines[ii].dist_boundary_bbb + lines[ii].tanh * time_list[i]){
                              lines[ii].dist_boundary_bbb = data_list[i] - lines[ii].tanh * time_list[i];
                        }
                        if(lines[ii].dist_bbb < tem_b){
                              lines[ii].dist_bbb = tem_b;
                        }
                  }
            }
            double margin_require = MarketInfo(symbol,MODE_MARGINREQUIRED);
            double tick_size = MarketInfo(symbol,MODE_TICKSIZE);
            double tick_value = MarketInfo(symbol,MODE_TICKVALUE);
            double margin_standar = MarketInfo("USDCAD",MODE_MARGINREQUIRED);
            double line_dist = MathAbs(lines[ii].bbb - lines[ii].dist_bbb)/MathSqrt(MathPow(lines[ii].tanh,2)+1);
            lines[ii].max_dropdown = margin_standar/margin_require * line_dist / tick_size * tick_value;
            double move_forward =MathAbs(lines[ii].tanh * (double(iTime(symbol, PERIOD_D1, 2))  -  double(iTime(symbol, PERIOD_D1, 3))));
            lines[ii].day_return = margin_standar/margin_require * move_forward / tick_size * tick_value;
            lines[ii].index = usable_cur[ii].index;
            lines[ii].h_or_l = usable_cur[ii].h_or_l;
            lines[ii].risk_retrun = lines[ii].day_return / lines[ii].max_dropdown;
            // Print(line.tanh, "  ", symbol, "  ", line.bbb, " now at:", line.tanh * iTime(symbol, PERIOD_M5, 20) + line.bbb);
            // Print(tanh * iTime(symbol, PERIOD_M5, 20)+ Bbb)
      }      
}

void OnStart()
{
      int search_list[10000];      
      for(int i=0;i<SymbolsTotal(0);i++){
            search_list[i] = i;
      }
      
      CUR usable_cur[1000];
      int len=OnRegression(50, 10, 0.75, 50, search_list, SymbolsTotal(0), usable_cur);
      for(int i=0;i<len;i++){
            search_list[i] = usable_cur[i].index;
      }
      len=OnRegression(10, 4, 0.75, 1, search_list, len, usable_cur);
      LINE Lines[1000];
      CalCurve(10,4,usable_cur,len,Lines);
      
      int len_LLine=0;
      LINE LLines[300];
      double treshold_price;
      for(int i=0; i< len; i++){            
            if(Lines[i].tanh > 0)
            {
                  treshold_price = Lines[i].tanh * (double(iTime("EURUSD",PERIOD_D1,0)) + 24*3600) + (Lines[i].dist_bbb < Lines[i].dist_boundary_bbb ? Lines[i].dist_bbb: Lines[i].dist_boundary_bbb);         
                  if(iClose(SymbolName(Lines[i].index,0),PERIOD_D1,0) < treshold_price)
                        continue;
            }
            if(Lines[i].tanh < 0){
                  treshold_price = Lines[i].tanh * (double(iTime("EURUSD",PERIOD_D1,0)) + 24*3600) + (Lines[i].dist_bbb > Lines[i].dist_boundary_bbb ? Lines[i].dist_bbb: Lines[i].dist_boundary_bbb);  
                  if (iClose(SymbolName(Lines[i].index,0),PERIOD_D1,0) > treshold_price)
                        continue;
            }
            if(Lines[i].risk_retrun > 0.5)
                  LLines[len_LLine++] = Lines[i];
      }

      for (int ii = 0; ii < len_LLine; ii++)
      {
            Print(SymbolName(LLines[ii].index,0));            
            Print(LLines[ii].day_return, " day earn");
            Print(LLines[ii].max_dropdown," drop");
            Print(LLines[ii].risk_retrun," rate");
            //Print(LLines[ii].bbb, " bbb");
            //Print(LLines[ii].dist_bbb, " dist bbb");
            //Print(LLines[ii].dist_boundary_bbb," dist_boundary_bbb");
            //Print(LLines[ii].h_or_l);
            // Print(Lines[ii].tanh," ",Lines[ii].bbb, " now at:", Lines[ii].tanh * iTime(SymbolName(usable_cur[ii].index,0), PERIOD_M5, 20) + Lines[ii].bbb);
      }
}
//+------------------------------------------------------------------+
