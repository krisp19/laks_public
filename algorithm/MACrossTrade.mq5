/*
Alogrithm to trade on Moving average cross. 
This snippet detects a fast moving average crossing a slow moving average to generate a buy or sell signal which can be used to enter positions. The snippet creates both long & shorts and exits when the MA cross is detected.
Usage of this algorithm for trading is at your own risk WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
*/

#include <Trade\Trade.mqh>

CTrade trade;

//globals for optimization. You may want to re-calibrate this every 3-4 days if trading on shorter intervals.
input int SLOW_PERIOD = 20;
input int FAST_PERIOD = 50;
input double LOT_SIZE = 0.5;

void OnTick()
{
   // Calculate the Ask Price
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   
   // Calculate the Bid Price
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   
   // Signal indicator
   string signal = "";
   
   // array to hold SMA & FMA candles
   double SlowMovingAverage[], FastMovingAverage[];
   
   int SlowMovingAverageDfn = iMA(
                                 _Symbol,    // Current Symbol on chart 
                                 _Period,    // Current Period on chart
                                 SLOW_PERIOD,// SMA candle duration
                                 0,          // SMA shift. Not used here
                                 MODE_EMA,   // MA type, EMA is default
                                 PRICE_CLOSE // Application type. Candle close by default
                                 );
                   
   int FastMovingAverageDfn = iMA(
                                 _Symbol,    // Current Symbol on chart 
                                 _Period,    // Current Period on chart
                                 FAST_PERIOD,// FMA candle duration
                                 0,          // FMA shift. Not used here
                                 MODE_EMA,   // MA type, EMA is default
                                 PRICE_CLOSE // Application type. Candle close by default
                                 );
   
   
   // Get the SMA data to a buffer
   CopyBuffer(
               SlowMovingAverageDfn,   //SMA definition
               0,    // buffer number
               0,    // start index
               3,    // number of candles to copy
               SlowMovingAverage //SMA array
             );
   
   // Get the FMA data to a buffer
   CopyBuffer(
               FastMovingAverageDfn,   //FMA definition
               0,    // buffer number
               0,    // start index
               3,    // number of candles to copy
               FastMovingAverage //FMA array
             );

   // MA X theory: When a FMA X's SMA from the top its a sell. Converse is a buy.
   // You may want to be doubly sure by waiting for a confirmation, the upside being you are protected against a sudden reversal, 
   // while the downside being a lost opportunity. But that is beyond the scope of this algortihm
   if ((FastMovingAverage[1] < SlowMovingAverage[1]) && (FastMovingAverage[2] > SlowMovingAverage[2]))
   {
      signal = "sell";
   }
   
   if ((FastMovingAverage[1] > SlowMovingAverage[1]) && (FastMovingAverage[2] < SlowMovingAverage[2]))
   {
      signal = "buy";
   }
   
   if (signal == "sell" && PositionsTotal() > 0)
   {
      CloseBuyPositions();
   }
   
   /////
   if (signal == "sell" && PositionsTotal() == 0 )
   {
      //Open a short position
      double stop = Bid-0.005;
      double take = Bid+0.005;
      Comment(StringFormat("Show prices\nAsk = %G\nBid = %G\nTake = %G\n Stop=%G",Ask,Bid,take,stop));
      trade.Sell(LOT_SIZE,NULL, Bid, stop, take, NULL);
   }
   /////
     
   if (signal == "buy" && PositionsTotal() == 0)
   {
      //Open a long position
      double stop = Ask-0.005;
      double take = Ask+0.005;
      // certain brokers may not allow instant reversal with a fixed stop & take. Hence you may want to pass 0.0 and fix stop/take later.
      trade.Buy(LOT_SIZE,NULL, Ask, /*stop*/0.0, /*take*/0.0, NULL);
   }
   
   /////
   if (signal == "buy" && PositionsTotal() > 0 )
   {
      CloseShortPositions();
   }
   /////
   
   //Chart output
   Comment("The Signal is: ",signal);
   //Comment(StringFormat("Show prices\nAsk = %G\nBid = %G\nTake = %G\n Stop=%G",Ask,Bid,take,stop));
}

void CloseShortPositions()
{
   for (int i = PositionsTotal()-1; i >=0; i--)
   {
      int ticket = PositionGetTicket(i);
      
      //identify currency pair
      string CurrencyPair = PositionGetSymbol(i);
      
      // obtain position direction
      int PositionDirection = PositionGetInteger(POSITION_TYPE);
      
      if (PositionDirection == POSITION_TYPE_SELL)
      {
         if (_Symbol == CurrencyPair)
         {
            trade.PositionClose(ticket);
         }
      }
   }  // for loop
}

void CloseBuyPositions()
{
   for (int i = PositionsTotal()-1; i >=0; i--)
   {
      int ticket = PositionGetTicket(i);
      
      //identify currency pair
      string CurrencyPair = PositionGetSymbol(i);
      
      // obtain position direction
      int PositionDirection = PositionGetInteger(POSITION_TYPE);
      
      if (PositionDirection == POSITION_TYPE_BUY)
      {
         if (_Symbol == CurrencyPair)
         {
            trade.PositionClose(ticket);
         }
      }
   }  // for loop
}
