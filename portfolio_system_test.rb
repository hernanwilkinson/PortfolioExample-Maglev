require "test/unit"
require "./portfolio_system"

class PortfolioSystemTest < Test::Unit::TestCase

  def testCanNotAddAccountsWithSameNumber
    system = PortfolioSystem.new
    system.addAccount(ReceptiveAccount.new("1","a name"))

    begin
      system.addAccount(ReceptiveAccount.new("1","a name"))
      self.fail
    rescue RuntimeError => aRuntimeError
      self.assert_equal(aRuntimeError.message,
        system.class.canNotAddAccountErrorDescriptionFor(ReceptiveAccount.new("1","a name")))
      self.assert_equal(system.numberOfAccounts,1)
    end
  end

  def testEachReceptiveAccountIteratesOnReceptiveAccountsOnly
    system = PortfolioSystem.new
    system.addAccount(ReceptiveAccount.new("1","a name"))
    system.addAccount(Portfolio.new("2","a name"))

    system.eachReceptiveAccount do |account|
      self.assert(account.isReceptiveAccount?)
    end
  end

  def testEachPortfolioIteratesOverPortfoliosOnly
    system = PortfolioSystem.new
    system.addAccount(ReceptiveAccount.new("1","a name"))
    system.addAccount(Portfolio.new("2","a name"))

    system.eachPortfolio do |account|
      self.assert(account.isPortfolio?)
    end
  end
end