module StatementImports
  class FileValidator
    ALLOWED_CONTENT_TYPES = %w[
      text/csv
      application/csv
      application/vnd.ms-excel
      application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
      application/pdf
    ].freeze

    MAX_FILE_SIZE = 15.megabytes

    def initialize(file)
      @file = file
    end

    def validate!
      raise ArgumentError, "File is missing" if @file.blank?

      validate_size!
      validate_extension!
      validate_content_type!

      true
    end

    private

    def validate_size!
      if @file.size > MAX_FILE_SIZE
        raise ArgumentError, "File size cannot exceed 15 MB"
      end
    end

    def validate_extension!
      extension = File.extname(@file.original_filename).downcase

      unless %w[.csv .xls .xlsx .pdf].include?(extension)
        raise ArgumentError, "Unsupported file extension: #{extension}"
      end
    end

    def validate_content_type!
      return if ALLOWED_CONTENT_TYPES.include?(@file.content_type)

      raise ArgumentError,
            "Unsupported content type: #{@file.content_type}"
    end
  end
end