require "test/unit"
require "date"
require "./account"

class AccountTest < Test::Unit::TestCase

  def setup
    @tenPesos = SimpleMeasure.new(10,:peso)
    @fiveDollars = SimpleMeasure.new(5,:dollars)
  end

  def testWhenAnAccountIsCreatedThenItsBalanceShouldBeZero

    account = ReceptiveAccount.new(123,'Some account')

    self.assert(account.balance().isZero?())

  end

  def testWhenRegisteringADepositThenTheBalanceShouldAddItsValue
    account = ReceptiveAccount.new(123,'Cash')
    Deposit.registerOn(account,Date.today,@tenPesos)

    self.assert_equal(account.balance(), @tenPesos)

  end

  def testWhenRegisteringAWithdrawThenTheBalanceShouldSubtractItsValue
    account = ReceptiveAccount.new(123,'Cash')
    Withdraw.registerOn(account,Date.today,@tenPesos)

    self.assert_equal(account.balance(), @tenPesos.negated())

  end

  def testAnAccountBalanceIsAffectedByAllTransactions
    account = ReceptiveAccount.new(123,'Cash')
    Deposit.registerOn(account,Date.today,@tenPesos)
    Deposit.registerOn(account,Date.today,@fiveDollars)

    self.assert_equal(account.balance(), @tenPesos+@fiveDollars)
  end

  def testAPortfolioBalanceIsTheSumOfItsAccountBalances
    fixIncomeInvestments = ReceptiveAccount.new(123,'Fix income')
    derivativeInvestments = ReceptiveAccount.new(456,'Derivative')
    portfolio = Portfolio.new(77,'Investments')
    portfolio.addAccount(fixIncomeInvestments)
    portfolio.addAccount(derivativeInvestments)

    tenBoden2012 = SimpleMeasure.new(12,:boden2012)
    Deposit.registerOn(fixIncomeInvestments,Date.today,tenBoden2012)

    oneHundredFutureDollarJan2013 = SimpleMeasure.new(100,:futureDollarJan2013)
    Deposit.registerOn(derivativeInvestments,Date.today,oneHundredFutureDollarJan2013)

    self.assert_equal(portfolio.balance(),tenBoden2012+oneHundredFutureDollarJan2013)
  end

  def testAPortfolioCanBeComposedByPortfolios
    fixIncomeInvestments = ReceptiveAccount.new(123,'Fix income')
    derivativeInvestments = ReceptiveAccount.new(456,'Derivative')
    highRiskPortfolio = Portfolio.new(77,'High Risk Investments')
    highRiskPortfolio.addAccount(fixIncomeInvestments)
    highRiskPortfolio.addAccount(derivativeInvestments)
    tenBoden2012 = SimpleMeasure.new(12,:boden2012)
    Deposit.registerOn(fixIncomeInvestments,Date.today,tenBoden2012)
    oneHundredFutureDollarJan2013 = SimpleMeasure.new(100,:futureDollarJan2013)
    Deposit.registerOn(derivativeInvestments,Date.today,oneHundredFutureDollarJan2013)

    moneyInvestments = ReceptiveAccount.new(789,'Money')
    lowRiskPortfolio = Portfolio.new(88,'Low Risk')
    lowRiskPortfolio.addAccount(moneyInvestments)
    Deposit.registerOn(moneyInvestments, Date.today,@tenPesos)

    allPortfolios = Portfolio.new(99,'All Investments')
    allPortfolios.addAccount(highRiskPortfolio)
    allPortfolios.addAccount(lowRiskPortfolio)

    self.assert_equal(allPortfolios.balance(),
      tenBoden2012+oneHundredFutureDollarJan2013+@tenPesos)
  end

  def testPortfolioCanNotHaveImmediateRepetitiveAccount
    fixIncomeInvestments = ReceptiveAccount.new(123,'Fix income')
    highRiskPortfolio = Portfolio.new(77,'High Risk Investments')
    highRiskPortfolio.addAccount(fixIncomeInvestments)

    begin
      highRiskPortfolio.addAccount(fixIncomeInvestments)
      self.fail
    rescue RuntimeError => aRuntimeError
      self.assert_equal(aRuntimeError.message,Portfolio.canNotAddAccountErrorDescriptionFor([fixIncomeInvestments]))
      self.assert_equal(highRiskPortfolio.numberOfAccounts,1)
    end
  end

  def testPortfolioCanNotShareAccountsWithAddedPortfolios
    fixIncomeInvestments = ReceptiveAccount.new(123,'Fix income')
    highRiskPortfolio = Portfolio.new(77,'High Risk Investments')
    highRiskPortfolio.addAccount(fixIncomeInvestments)

    lowRiskPortfolio = Portfolio.new(88,'Low Risk')
    lowRiskPortfolio.addAccount(fixIncomeInvestments)

    begin
      highRiskPortfolio.addAccount(lowRiskPortfolio)
      self.fail
    rescue RuntimeError => aRuntimeError
      self.assert_equal(aRuntimeError.message,Portfolio.canNotAddAccountErrorDescriptionFor([fixIncomeInvestments]))
      self.assert_equal(highRiskPortfolio.numberOfAccounts,1)
    end
  end

  def testIsReceptiveAccountReturnsTrueForReceptiveAccount
    self.assert(ReceptiveAccount.new(1,"a name").isReceptiveAccount?)
    self.assert(!ReceptiveAccount.new(1,"a name").isPortfolio?)
  end

  def testIsPortfolioReturnsTrueForPortfolio
    self.assert(Portfolio.new(1,"a name").isPortfolio?)
    self.assert(!Portfolio.new(1,"a name").isReceptiveAccount?)
  end
end