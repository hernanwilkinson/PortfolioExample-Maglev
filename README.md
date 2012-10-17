PortfolioExample-Maglev
=======================

Code used during the presentation of Maglev at the RubyConf Argentina 2012.

Steps:
1) Install maglev: rvm install maglev
2) Load code in maglev: ruby load_code.rb
3) Create a persistent PortfolioSystem: ruby create_portfolio_system.rb [name]
   Example: ruby create_portfolio_system MyPortfolio
4) Start the SinatraWebApp: ruby runner.rb Maglev 4567 MyPortfolio
5) Use it pointing your webbrowser to localhost:4567
6) Start another SinatraWebApp for the same portfolio:
   ruby runner.rb Maglev 4568 MyPortfolio
6) Use it pointing your webbrowser to localhost:4568
   See how objects are shared between apps

7) You can use the same app with normal ruby vm and/or without persistence
   If you want to run it with a normal ruby vm, do:
   a) rvm use [you_ruby_vm]  ie: rvm use ruby-1.9.3-p194
   b) ruby runner.rb ruby 4567
      This will start a SinatraApp that does not use Maglev

8) See all the tests and explore the model... I hope you enjoy it!

