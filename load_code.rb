Maglev.abort_transaction
Maglev.persistent do
  require 'date'
  # Use load rather than require to force re-reading of the files
  load 'measure.rb'
  load 'account_transaction.rb'
  load 'account.rb'
  load 'portfolio_system.rb'
end
Maglev.commit_transaction
 
