
require "csv"
require "date"
require "bigdecimal"

module StatementImports
  module Parsers
    class CsvParser
      HEADER_ALIASES = {
        date: %w[date transactiondate valuedate],
        description: %w[description narration particulars remarks],
        amount: %w[amount transactionamount],
        debit: %w[debit withdrawal withdrawals],
        credit: %w[credit deposit deposits],
        reference_number: %w[referencenumber transactionid utr cheque number]
      }.freeze

      def initialize(input)
        @input = input
      end

      def call
        data = @input.respond_to?(:read) ? @input.read : @input.to_s

        rows = CSV.parse(data, headers: true, liberal_parsing: true)

        headers = rows.headers.compact
        columns = resolve_columns(headers)

        unless columns[:date] && columns[:description]
          raise ArgumentError, "CSV must contain date and description columns"
        end

        unless columns[:amount] || columns[:debit] || columns[:credit]
          raise ArgumentError, "CSV must contain amount, debit or credit column"
        end

        rows.each_with_index.filter_map do |row, index|
          next if row.fields.all? { |value| value.to_s.strip.empty? }

          normalize_row(row, columns, index + 2)
        end
      end

      private

      def resolve_columns(headers)
        normalized = headers.index_with do |header|
          normalize_header(header)
        end

        HEADER_ALIASES.each_with_object({}) do |(key, aliases), result|
          result[key] = normalized.find do |_header, value|
            aliases.include?(value)
          end&.first
        end
      end

      def normalize_header(header)
        header.to_s.downcase.gsub(/[^a-z0-9]/, "")
      end

      def normalize_row(row, columns, row_number)
        date = Date.parse(value(row, columns[:date]))

        description = value(row, columns[:description])

        amount, type = resolve_amount(row, columns)

        {
          transaction_date: date,
          description: description,
          amount: amount,
          transaction_type: type,
          reference_number: value(row, columns[:reference_number])
        }
      rescue StandardError => e
        raise ArgumentError, "CSV row #{row_number}: #{e.message}"
      end

      def resolve_amount(row, columns)
        if columns[:debit] || columns[:credit]
          debit = parse_amount(value(row, columns[:debit]))
          credit = parse_amount(value(row, columns[:credit]))

          if debit.positive? && credit.positive?
            raise ArgumentError, "Both debit and credit contain amounts"
          elsif debit.positive?
            [debit, "expense"]
          elsif credit.positive?
            [credit, "income"]
          else
            raise ArgumentError, "Missing debit or credit amount"
          end
        else
          raw = value(row, columns[:amount])
          amount = BigDecimal(raw.to_s.gsub(",", "").strip)

          raise ArgumentError, "Amount cannot be zero" if amount.zero?

          type = amount.negative? ? "expense" : "income"

          [amount.abs, type]
        end
      end

      def parse_amount(raw)
        return BigDecimal("0") if raw.blank?

        cleaned = raw.to_s.gsub(/[₹$,\s]/, "")

        BigDecimal(cleaned)
      end

      def value(row, column)
        return nil unless column

        row[column]&.strip
      end
    end
  end
end
