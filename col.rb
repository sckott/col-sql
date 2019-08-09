require 'aws-sdk'
require 'faraday'
require 'sqlite3'
require 'date'
require 'zip'

Aws.config.update({
  region: 'us-west-2',
  credentials: Aws::Credentials.new(ENV['AWS_S3_WRITE_ACCESS_KEY'], ENV['AWS_S3_WRITE_SECRET_KEY'])
})
$s3 = Aws::S3::Client.new

$col_url = "http://www.catalogueoflife.org/DCA_Export/zip-fixed/2019-annual.zip"

module Col

	def self.fetch
		puts 'fetching/unzipping data from COL servers'
		fetch_col()
		unzip_col()
	end

	def self.sql
		puts 'creating SQLite database, and loading COL taxonomy'
		system('sh do_col.sh')
	end

	def self.zip
		puts 'zipping sqlite db file into a zip file'
		zip_up()
	end

	def self.s3
		puts 'uploading SQLite database to Amazon S3'
		to_s3()
	end

	def self.all
		if is_new?
			puts 'new data, updating'
			fetch_col()
			unzip_col()
			system('sh do_col.sh')
			zip_up()
			to_s3()
			clean_up()
		else
			puts 'data is old, not updating'
		end
	end

	def self.clean
		clean_up()
	end

end

def is_new?
	# initialize Faraday connection object
	conn = Faraday.new do |x|
	  x.adapter Faraday.default_adapter
	end

	# check last-modified header
	res = conn.head $col_url;
	lm = DateTime.parse(res.headers['last-modified']).to_time

	# file last modified
	begin
		fm = File.stat("2019-annual.zip").mtime
	rescue Exception => e
		fm = nil
	end

	if fm.nil?
		return true
	end

	# return boolean
	return lm > fm
end

def fetch_col
	if !File.exist?('2019-annual.zip')
		# initialize Faraday connection object
		conn = Faraday.new do |x|
		  x.adapter Faraday.default_adapter
		end

		# get zip file
		res = conn.get $col_url;

		# write zip file to disk
		File.open('2019-annual.zip', 'wb') { |fp| fp.write(res.body) }
	else
		puts "'2019-annual.zip' found, skipping download"
	end
end

def unzip_col
	Zip::File.open('2019-annual.zip') do |zip_file|
	  zip_file.glob("*.txt") do |f|
			begin
				zip_file.extract(f, f.name) unless File.exist?(f.name)
			end
	  end
	end
end

def zip_up
	Zip::File.open('col.zip', Zip::File::CREATE) do |zip|
	  zip.add("col.sqlite", "col.sqlite")
	end
end

def to_s3
	File.open("col.zip", 'rb') do |f|
  		$s3.put_object(bucket: 'taxize-dbs', key: 'col.zip', body: f)
	end
end

def clean_up
	files_to_clean = ["taxa.txt", "reference.txt", "vernacular.txt",
		"speciesprofile.txt", "distribution.txt", "description.txt",
		"2019-annual.zip", "gbif.sqlite", "col.sqlite", "col.zip"]
	files_to_clean.each { |x| File.unlink(x) unless !File.exists?(x) }
end
