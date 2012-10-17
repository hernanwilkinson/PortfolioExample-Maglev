require 'rubygems'
require 'sinatra/base'
require './portfolio_system'

class PortfolioSinatraApplication < Sinatra::Base

  def initialize(*args)
    super
    self.initializePortfolioSystem
  end

  def initializePortfolioSystem
    raise SubclassResponsibility
  end

  def urlFor(anAccount)
    "/"+ (anAccount.isPortfolio? ? "portfolio" : "account") + "/" + anAccount.number
  end

  get '/' do
    puts 'attending /'
    erb :home
  end

  get '/account/:number' do
    puts 'attending /account/number'
    @currentAccount = @portfolioSystem.accountIdentifiedAs(params[:number])
    erb :account
  end

  get '/portfolio/:number' do
    puts 'attending /portfolio'
    @currentPortfolio = @portfolioSystem.accountIdentifiedAs(params[:number])
    erb :portfolio
  end

  post '/registerTransaction' do
    puts 'attending /registerTransaction'
    date = Date.parse(params[:date])
    amount = params[:amount].to_i
    unit = params[:instrumentName]
    value = SimpleMeasure.new(amount,unit)
    if params[:action]=='Deposit'
      transaction = Deposit
    else
      transaction = Withdraw
    end
    transaction.registerOn(@portfolioSystem.accountIdentifiedAs(params[:accountNumber]),date,value)
    redirect '/account/'+params[:accountNumber]
  end

  post '/addAccount' do
    puts 'attending /addAccount'
    @portfolioSystem.addAccount(
        ReceptiveAccount.new(params[:accountNumber],params[:accountName]))
    redirect '/'
  end

  post '/addPortfolio' do
    puts 'attending /addPortfolio'
    @portfolioSystem.addAccount(
        Portfolio.new(params[:portfolioNumber],params[:portfolioName]))
    redirect '/'
  end

  post '/addAccountToPortfolio' do
    puts 'attending /addAccountToPortfolio'
    portfolio = @portfolioSystem.accountIdentifiedAs(params[:portfolioNumber])
    account = @portfolioSystem.accountIdentifiedAs(params[:accountNumber])
    portfolio.addAccount(account)
    redirect '/portfolio/'+params[:portfolioNumber]
  end

end

class PortfolioCommonRubySinatraApplication < PortfolioSinatraApplication

  def initializePortfolioSystem
    #Creates a new PortfolioSystem every time it is run...
    @portfolioSystem = PortfolioSystem.new
  end

end
class PortfolioMaglevSinatraApplication < PortfolioSinatraApplication

  def initializePortfolioSystem
    #It looks in the persistent root the PortfolioSystem to use
    #This should be done better, it is like that due to my lack of knowledge about sinatra configuration
    @portfolioSystem = ARGV.size > 1 ? Maglev::PERSISTENT_ROOT[ARGV[2]] : PortfolioSystem.new
  end

  before do
    #This is to get a new view of the repository
    Maglev.abort_transaction
  end

  after do
    #With this all changed objects are persisted automatically
    #I'm not taking care of transaction conflicts
    Maglev.commit_transaction
  end

end
