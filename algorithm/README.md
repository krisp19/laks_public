How to Trade a Moving average cross
---
This EA algoritm trades on EMA cross. Entry and exit criteria is EMA cross. Although written for a FX pair, this EA works very well on commodoties, indices & stocks. 

Warning
---
Ensure to calibrate the fast moving average, slow moving averages & lot size correctly. Check with your broker and adjust lot size accordingly. Always test against a demo account before going live with this algo. If configured & calibrated correctly this bot can generate money. Misconfiguring the EA will invariably result in loss. Remember: Not doing anything is better than losing money. 

Business Pre-Requisites
----
1. You have an account with a broker.
2. Your broker allows algo trading in spread account.

Technical Pre-Requisites
----
1. Your leverage is configured correctly. Usually 1:10 + 
2. You have a broker connection configured correctly.
3. You understand MQL.

EA Description
----
The simple MQL5 EA opens shorts and longs on an EMA Cross. When a fast moving average crosses a slow moving average, a buy or sell signal is generated which can be used as a trigger to enter a short or a long position with a fixed stop & take. If the MA cross happens before the fixed stop & take the position is closed. 

To detect a cross over test the previous 2 candles as under:

if fma[1] < sma[1] && fma[2] > sma[2] 
generate sell

if fma[1] > sma[1] && fma[2] < sma[2] 
generate buy 

[1] represents previous candle and [2] represents candle prior to previous candle.  

Flow
---
![image](https://user-images.githubusercontent.com/55232057/147267280-53e336eb-e401-415c-a61c-598433ec0724.png)
