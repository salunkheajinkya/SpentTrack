
module StatementImports
  class Processor
    attr_reader :imports

    def initialize(account:, files:)
      @account = account
      @files = Array(files)
      @imports = []
    end

    def call
      validate_inputs!

      # Validate all files before creating import records.
      @files.each do |file|
        FileValidator.new(file).validate!
      end

      @files.each do |file|
        process_file(file)
      end

      @imports
    end

    private

    def validate_inputs!
      raise ArgumentError, "Account is required" unless @account&.persisted?

      raise ArgumentError, "At least one file is required" if @files.empty?
    end

    def process_file(file)
      import = @account.statement_imports.create!(
        filename: file.original_filename,
        status: "pending"
      )

      @imports << import

      import.files.attach(file)

      rows = []

      import.files.blobs.first.open do |tempfile|
        rows = Parsers::CsvParser.new(tempfile).call
      end

      import.update!(total_rows: rows.size)

      imported = 0
      duplicates = 0

      ActiveRecord::Base.transaction do
        rows.each do |attributes|
          detector = DuplicateDetector.new(
            account: @account,
            attributes: attributes
          )

          if detector.duplicate?
            duplicates += 1
            next
          end

          import.transactions.create!(
            account: @account,
            **attributes
          )

          imported += 1
        end

        import.update!(
          status: "completed",
          imported_rows: imported,
          duplicate_rows: duplicates,
          failed_rows: 0,
          error_details: []
        )
      end

    rescue StandardError => e
      import&.update!(
        status: "failed",
        total_rows: rows.size,
        imported_rows: 0,
        failed_rows: rows.empty? ? 1 : rows.size,
        error_details: [{ "message" => e.message }]
      )

      Rails.logger.error(
        "Statement import failed: #{e.class}: #{e.message}"
      )
    end
  end
end

