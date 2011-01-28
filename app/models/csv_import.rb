class CSVImport
  #
  # from console
  # > (thedata = CSVImport.read_csv)==nil
  # > CSVImport.set_data(thedata)
  #
  # ... edit some stuff in this file
  # > reload!;CSVImport.set_data(thedata)
  #
  require 'csv'
  @@data = []

  #def self.read_csv( fname )
  def self.read_csv
    csv_data = CSV.read "public/tbl_contacts.csv" 
    headers = csv_data.shift.map {|i| i.to_s }
    string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
    @@data = string_data.map {|row| Hash[*headers.zip(row).flatten] }
  end

  def self.set_data( data )
    @@data = data
    nil
  end

  def self.get_data( ndx )
    @@data[ndx]
  end

  def self.is_company( rec )
    rec["c_name"] == rec["c_company"] 
  end

  def self.is_person( rec )
    (rec["c_name"] == rec["c_first_name"] + " " + rec["c_last_name"]) or (rec["c_name"] == rec["c_person"])
  end

  def self.get_fld( ndx, fld )
    fld + ":" + @@data[ndx][fld]
  end

  def self.get_given_name( rec )
    rec["c_first_name"] + " " + rec["c_last_name"]
  end

  def self.lbl( rec, fld )
    fld + ":" + rec[fld]
  end

  def self.get_name_info( rec )
    self.lbl(rec,"c_name") + ", " + lbl(rec,"c_company") + ", " + lbl(rec,"c_person") + ", " + lbl(rec,"c_first_name") + ", " + lbl(rec,"c_last_name")
  end

  def self.no_company_info_recs
    i=0
    @@data.each do |rec|
      if rec["c_company"].empty?
        puts i.to_s + ":" + get_name_info(rec)
      end
      i+=1
    end
  end

  def self.count_parties
    puts "Total Records: " + @@data.length.to_s
    npersons = 0
    norgs = 0
    i = 0

    @@data.each do |rec|
      if self.is_person(rec) then
        npersons+=1
      elsif self.is_company(rec)
        norgs+=1
      else
        puts self.get_name_info(rec)
      end
      i+=1

    end
    puts "People: " + npersons.to_s
    puts "Organizations: " + norgs.to_s
    puts "Foo Bar"
  end

  def self.import_data
    i=0
    person=[]
    org_person=[]
    org=[]
    other=[]
    @@data.each do |rec|
      if !rec["c_company"].blank? # i.e. rec has company data
        if (!rec["c_first_name"].blank? or !rec["c_last_name"].blank? or !rec["c_person"].blank?)
          org_person.push(rec)
        else
          org.push(rec)
        end
      else
        if (!rec["c_first_name"].blank? or !rec["c_last_name"].blank? or !rec["c_person"].blank? or !rec["c_name"].blank?)
          person.push(rec)
        else
          other.push(rec)
        end
      end
      i+=1
    end

    person.each do |p|
      puts self.get_name_info(p)
    end

    puts "org_person: " + org_person.length.to_s
    puts "org:        " + org.length.to_s
    puts "person:     " + person.length.to_s
    puts "other:      " + other.length.to_s
    puts "all:        " + @@data.length.to_s
  end

end

