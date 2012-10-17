require 'rubygems'
require 'sinatra'
require './portfolio_sinatra_application'

def commandLinePort
  ARGV.size > 2 ? ARGV[1].to_i : 4567
end

def applicationType
  if ARGV.size > 1
    if ARGV[0]=='Maglev'
      PortfolioMaglevSinatraApplication
    else
      PortfolioCommonRubySinatraApplication
    end
  end
end

applicationType.run! :port => commandLinePort
