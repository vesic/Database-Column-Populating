require 'csv'
require 'geocoder'

COLUMN_ORDER = 14
FILE_TO_READ = ARGV[0]  || 'input.csv'
FILE_TO_WRITE = ARGV[1] || 'output.csv';
GOOGLE_API_KEY = ARGV[2]

Geocoder.configure(
  :api_key => GOOGLE_API_KEY
)

class Handler
  def initialize()
    # read file in
    @file = CSV.open(FILE_TO_READ)
    @arr = []
  end
  
  # read file contents
  def read_from_file
    @file.each do |line|
      # for each city get geocoder response
      city = Geocoder.search(line[COLUMN_ORDER])
      # if not empty array
      unless city.empty?
        # append coordinates
        line << city.first.data["geometry"]["location"]["lat"]
        line << city.first.data["geometry"]["location"]["lng"]
      # if not usefull
      else
        line << 'N/A' << 'N/A'
      end
      # push combined line
      @arr << line
      puts line.inspect
      # google api qouta workaround
      sleep(0.3)
    end
  end
  
  def write_to_file
    CSV.open(FILE_TO_WRITE, 'w') do |csv_object|
      @arr.each do |line|
        csv_object << line
      end
    end
  end
end

h = Handler.new
h.read_from_file
h.write_to_file