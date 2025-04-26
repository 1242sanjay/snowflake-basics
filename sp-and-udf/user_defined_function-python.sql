CREATE OR REPLACE FUNCTION addone(i INT)
  RETURNS INT
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.9'
  HANDLER = 'addone_py'
AS $$
def addone_py(i):
 return i+1
$$;

select addone(5);

/*
-- Creating a Python UDF with code uploaded from a stage
1. Create a Python file named sleepy.py - 
    def snore(n):   # return a series of n snores
      result = []
      for a in range(n):
        result.append("Zzz")
      return result

2. Put the file on stage location 
    put
    file:///Users/Me/sleepy.py
    @~/
    auto_compress = false
    overwrite = true
    ;

3. Create the UDF. The handler specifies the module and the function.
    CREATE OR REPLACE FUNCTION dream(i INT)
      RETURNS VARIANT
      LANGUAGE PYTHON
      RUNTIME_VERSION = '3.9'
      HANDLER = 'sleepy.snore'
      IMPORTS = ('@~/sleepy.py')

4. Call the UDF
    SELECT dream(3);

*/

CREATE TABLE stocks_table (symbol VARCHAR, quantity NUMBER, price NUMBER(10,2));
INSERT INTO stocks_table (symbol, quantity, price) VALUES 
   ('A', 3,  10.00),
   ('B', 5, 100.00)
   ;

CREATE OR REPLACE FUNCTION stock_sale_average(symbol VARCHAR, quantity NUMBER, price NUMBER(10,2))
  RETURNS TABLE (symbol VARCHAR, total NUMBER(10,2))
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  PACKAGES = ('numpy')
  HANDLER = 'StockSaleAverage'
AS $$
import numpy as np

class StockSaleAverage:
    def __init__(self):
      self._price_array = []
      self._quantity_total = 0
      self._symbol = ""

    def process(self, symbol, quantity, price):
      self._symbol = symbol
      self._price_array.append(float(price))
      cost = quantity * price
      yield (symbol, cost)

    def end_partition(self):
      np_array = np.array(self._price_array)
      avg = np.average(np_array)
      yield (self._symbol, avg)
$$;

SELECT stock_sale_average.symbol, total
  FROM stocks_table,
  TABLE(stock_sale_average(symbol, quantity, price)
    OVER (PARTITION BY symbol));

