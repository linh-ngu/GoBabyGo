class RenameLedgerToFinance < ActiveRecord::Migration[7.0]
  def change
    rename_table :ledgers, :finances
  end
end
