require "./subclass_responsibility"

class AccountTransaction
  def <=> anAccountTransaction
    self.date <=> anAccountTransaction.date
  end

  def date
    raise SubclassResponsibility
  end

  def typeDescription
    raise SubclassResponsibility
  end

  def value
    raise SubclassResponsibility
  end

  def affect (aBalance)
    raise SubclassResponsibility
  end

  def self.registerOn(anAccount,aDate,aValue)
    anAccount.register(self.new(aDate,aValue))
  end
end

class Deposit < AccountTransaction
  def initialize(aDate,aValue)
    @date = aDate
    @value = aValue
  end

  def date
    @date
  end

  def typeDescription
    'Deposit'
  end

  def value
    @value
  end

  def affect (aBalance)
    aBalance + @value
  end
end

class Withdraw < AccountTransaction
  def initialize(aDate,aValue)
    @date = aDate
    @value = aValue
  end

  def date
    @date
  end

  def typeDescription
    'Withdraw'
  end

  def value
    @value
  end

  def affect (aBalance)
    aBalance - @value
  end
end
