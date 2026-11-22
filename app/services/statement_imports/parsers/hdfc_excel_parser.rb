
require "roo"
require "date"
require "bigdecimal"

module StatementImports
  module Parsers
    class HdfcExcelParser
      REQUIRED_HEADERS = [
        "date",
        "narration",
        "chq./ref.no.",
        "withdrawal amt.",
        "deposit amt."
      ].freeze

      def initialize(input)
        @input = input
      end

      def call
        workbook = Roo::Spreadsheet.open(
          @input,
          extension: :xls
        )

        sheet = workbook.sheet(0)
        header_row = find_header_row(sheet)

        raise ArgumentError, "HDFC transaction header not found" unless header_row

        headers = sheet.row(header_row).map do |header|
          normalize_header(header)
        end

        indexes = resolve_columns(headers)

        transactions = []

        ((header_row + 1)..sheet.last_row).each do |row_number|
          row = sheet.row(row_number)

          next if row.all? { |value| value.to_s.strip.empty? }
          next if row.all? { |value| value.to_s.include?("*") }

          date_value = row[indexes[:date]]
          description = row[indexes[:description]]

          next unless valid_transaction_date?(date_value)
          next if description.blank?

          transactions << normalize_row(row, indexes, row_number)
        end

        transactions
      end

      private

      def valid_transaction_date?(value)
        return true if value.is_a?(Date) || value.is_a?(DateTime)

        value.to_s.strip.match?(/\A\d{2}\/\d{2}\/\d{2}\z/)
      end

      def find_header_row(sheet)
        (1..sheet.last_row).find do |row_number|
          headers = sheet.row(row_number).map do |value|
            normalize_header(value)
          end

          REQUIRED_HEADERS.all? { |header| headers.include?(header) }
        end
      end

      def normalize_header(value)
        value.to_s.strip.downcase.gsub(/\s+/, " ")
      end

      def resolve_columns(headers)
        {
          date: headers.index("date"),
          description: headers.index("narration"),
          reference_number: headers.index("chq./ref.no."),
          debit: headers.index("withdrawal amt."),
          credit: headers.index("deposit amt.")
        }
      end

      def normalize_row(row, indexes, row_number)
        debit = parse_amount(row[indexes[:debit]])
        credit = parse_amount(row[indexes[:credit]])

        if debit.positive? && credit.positive?
          raise ArgumentError, "Both debit and credit found"
        end

        amount, type =
          if debit.positive?
            [debit, "expense"]
          elsif credit.positive?
            [credit, "income"]
          else
            raise ArgumentError, "Missing transaction amount"
          end

        {
          transaction_date: parse_date(row[indexes[:date]]),
          description: row[indexes[:description]].to_s.strip,
          amount: amount,
          transaction_type: type,
          reference_number: row[indexes[:reference_number]]&.to_s&.strip
        }
      rescue StandardError => e
        raise ArgumentError, "HDFC Excel row #{row_number}: #{e.message}"
      end

      def parse_date(value)
        return value.to_date if value.respond_to?(:to_date) && !value.is_a?(String)

        Date.strptime(value.to_s.strip, "%d/%m/%y")
      end

      def parse_amount(value)
        return BigDecimal("0") if value.blank?

        BigDecimal(value.to_s.gsub(/[₹,\s]/, ""))
      end
    end
  end
end
