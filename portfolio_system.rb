require './account'

class PortfolioSystem

  def initialize
    @accounts = []
  end

  def eachReceptiveAccount(&block)
    @accounts.select { |account| account.isReceptiveAccount? }.each(&block)
  end

  def accountIdentifiedAs(aNumber)
    @accounts.detect {| account | account.isIdentifiedAs?(aNumber)}
  end

  def addAccount(accountToAdd)
    self.assertCanAddAccount(accountToAdd)
    @accounts << accountToAdd
  end

  def assertCanAddAccount(account)
    if self.accountIdentifiedAs(account.number)
      raise self.class.canNotAddAccountErrorDescriptionFor(account)
    end
  end

  def eachPortfolio(&block)
    @accounts.select { |account| account.isPortfolio? }.each(&block)
  end

  def numberOfAccounts
    @accounts.size
  end

  def self.canNotAddAccountErrorDescriptionFor(account)
    "An account identified as "+ account.number + " already exist"
  end
end
