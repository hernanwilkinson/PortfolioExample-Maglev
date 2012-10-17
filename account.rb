require "set"
require "./measure"
require "./account_transaction"
require "./subclass_responsibility"

class Account
  def number
    raise SubclassResponsibility
  end

  def name
    raise SubclassResponsibility
  end

  def isIdentifiedAs?(aNumber)
    self.number==aNumber
  end

  def isPortfolio?
    raise SubclassResponsibility
  end

  def isReceptiveAccount?
    !self.isPortfolio?
  end

  def allAccounts
    raise SubclassResponsibility
  end

  def balance
    raise SubclassResponsibility
  end

  def nothing
    SimpleMeasure.nothing
  end
end

class ReceptiveAccount < Account

  def initialize (aNumber,aName)
    @number = aNumber
    @name = aName
    @transactions = SortedSet.new
  end

  def number
    @number
  end

  def name
    @name
  end

  def isPortfolio?
    false
  end

  def allAccounts
    [self]
  end

  def balance
    @transactions.inject(self.nothing()) { |balance,transaction| transaction.affect(balance)}
  end

  def register (aTransaction)
    @transactions << aTransaction
  end

  def eachTransaction(&block)
    @transactions.each(&block)
  end

end

class Portfolio < Account
  def initialize (aNumber,aName)
    @number = aNumber
    @name = aName
    @accounts = []
  end

  def number
    @number
  end

  def name
    @name
  end

  def isPortfolio?
    true
  end

  def addAccount(anAccount)
    self.assertCanAddAccount(anAccount)

    @accounts << anAccount
  end

  def assertCanAddAccount(anAccount)
    sharedAccounts = self.allAccounts & anAccount.allAccounts
    if !sharedAccounts.empty?
      raise self.class.canNotAddAccountErrorDescriptionFor(sharedAccounts)
    end
  end

  def allAccounts
    @accounts.flatten
  end

  def balance
    @accounts.inject(self.nothing()) { |balance,account| balance+account.balance()}
  end

  def eachAccount(&block)
    @accounts.each(&block)
  end

  def numberOfAccounts
    self.allAccounts.size
  end

  def self.canNotAddAccountErrorDescriptionFor(aCollectionOfAccounts)
    "The account(s) "+(aCollectionOfAccounts.collect { |account| account.name }).to_s+" are already part of the portfolio"
  end
end

