
module StatementImports
  class DuplicateDetector
    def initialize(account:, attributes:)
      @account = account
      @attributes = attributes
    end

    def duplicate?
      scope = @account.transactions.where(
        transaction_date: @attributes[:transaction_date],
        amount: @attributes[:amount],
        transaction_type: @attributes[:transaction_type]
      )

      if @attributes[:reference_number].present?
        scope.where(
          reference_number: @attributes[:reference_number]
        ).exists?
      else
        scope.where(
          description: @attributes[:description]
        ).exists?
      end
    end
  end
end
