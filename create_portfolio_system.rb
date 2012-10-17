#Creates a persist a PortfolioSystem in Maglev

Maglev.abort_transaction
Maglev::PERSISTENT_ROOT[ARGV[0]]=PortfolioSystem.new
Maglev.commit_transaction

