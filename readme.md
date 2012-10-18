PortfolioExample-Maglev
=======================

Code used during the presentation of **Maglev** at the RubyConf Argentina 2012.

Steps:

1. Install maglev
   
   `rvm install maglev`

2. Load code in maglev

   `ruby load_code.rb`

3. Create a persistent PortfolioSystem 
   
   `ruby create_portfolio_system.rb [name]`

  > Example: `ruby create_portfolio_system MyPortfolio`

4. Start the SinatraWebApp

   `ruby runner.rb Maglev 4567 MyPortfolio`

5. Use it pointing your browser to **localhost:4567**

6. Start another _SinatraWebApp_ for the same portfolio

  > ruby runner.rb Maglev 4568 MyPortfolio

7. Use it pointing your browser to **localhost:4568**

  > See how objects are shared between apps

8. You can use the same app with normal ruby VM and/or without persistence

  If you want to run it with a normal ruby VM, and you have __rvm__ do:
  ```bash
   rvm use <your_ruby_vm> # ie: `rvm use ruby-1.9.3-p194`
   ruby runner.rb ruby 4567
  ```

  This will start a SinatraApp that does not use **Maglev**

9. See all the tests and explore the model... I hope you enjoy it!
