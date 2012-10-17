class SubclassResponsibility < Exception

  def message
    'Should be implemented by subclass'
  end

end