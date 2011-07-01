class CSVImport
#
# from console
# > (thedata = CSVImport.read_stash)==nil
# > CSVImport.set_data(thedata)
#
# ... edit some stuff in this file
# > reload!;CSVImport.set_data(thedata)
#
  require 'csv'
  @@data = []
  @@org_person = []

  @@org_person = []
  @@org = []
  @@other = []
  @@data_ct = 0

  #def self.read_csv( fname )
  def self.read_csv
    csv_data = CSV.read "public/tbl_contacts.csv" 
    headers = csv_data.shift.map {|i| i.to_s }
    string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
    @@data = string_data.map {|row| Hash[*headers.zip(row).flatten] }
  end

  def self.stash_csv
    marshall_dump = Marshal.dump(@@data)
    file = File.new("public/tbl_contacts.stash",'w')
    file.write marshall_dump
    file.close
    nil
  end

  def self.read_stash
    file = File.open("public/tbl_contacts.stash",'r')
    @@data = Marshal.load file.read
    file.close
    @@data
  end

  def self.standardize_address( rec, fld )
    unless rec[fld].blank?
      addr = "'" + rec[fld] + "'"
      rec[fld] = `php public/cli_batch.php #{addr}`
      puts addr + '=>' + rec[fld]
    end
  end

  def self.standardize_addresses
    @@data.each do |rec|
      ["c_addr1", "c_addr2", "c_shipto_addr1", "c_shipto_addr2"].each do |fld|
         standardize_address( rec, fld )
      end
    end
    nil
  end

  def self.test_address_conversion
    i=0
    @@data.each do |o|
      unless o["c_addr1"].blank?
        addr = "'" + o["c_addr1"] + "'"
        rval = `php public/cli_batch.php #{addr}`
        puts i.to_s + " " + o["c_addr1"] + "=>" + rval
        o["c_addr1"]=rval
        break
      end
      i+=1
    end
    nil
  end

  def self.set_data( data )
    @@data = data
    @@person=[]
    @@org_person=[]
    @@org=[]
    @@other=[]
    @@data.each do |rec|
      if !rec["c_company"].blank? # i.e. rec has company data
        if (!rec["c_first_name"].blank? or !rec["c_last_name"].blank? or !rec["c_person"].blank?)
          @@org_person.push(rec)
        else
          @@org.push(rec)
        end
      else
        if (!rec["c_first_name"].blank? or !rec["c_last_name"].blank? or !rec["c_person"].blank? or !rec["c_name"].blank?)
          @@person.push(rec)
        else
          if rec["c_city"].blank? 
            @@other.push(rec)
          else
            @@org.push(rec)
          end 
        end
      end
      @@data_ct+=1
    end

    puts "org_person: " + @@org_person.length.to_s
    puts "org:        " + @@org.length.to_s
    puts "person:     " + @@person.length.to_s
    puts "other:      " + @@other.length.to_s
    puts "all:        " + @@data.length.to_s

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

  def self.addr_is_empty( rec )
    ( rec["c_addr1"].empty? and rec["c_addr2"].empty? and rec["c_state"].empty? and rec["c_zip"].empty? )
  end

  def self.shipto_addr_is_empty( rec )
    ( rec["c_shipto_addr1"].empty? and rec["c_shipto_addr2"].empty? and rec["c_shipto_state"].empty? and rec["c_shipto_zip"].empty? )
  end

  def self.address_hash( rec )
     ":address1=>'" + rec["c_addr1"] + "',:address2=>'" + rec["c_addr2"] + "',:city=>'" + rec["c_city"] + "',:state=>'" + rec["c_state"] + "',:zip=>'" + rec["c_zip"] + "'"
  end

  def self.compose_address( rec )
     new_addr = Address.new( :address1=>rec["c_addr1"],
                             :address2=>rec["c_addr2"],
                             :city=>rec["c_city"],
                             :state=>rec["c_state"],
                             :zip=>rec["c_zip"],
                             :country=>rec["c_country"])
  end 

  def self.assign_address( addr, rec )
     addr.address1=rec["c_addr1"]
     addr.address2=rec["c_addr2"]
     addr.city=rec["c_city"]
     addr.state=rec["c_state"]
     addr.zip=rec["c_zip"]
     addr.country=rec["c_country"]
  end

  def self.callable_assign( this_callable, rec)
        unless rec["c_phone"].empty?
          this_callable.phone_numbers.build( :dial_code=>rec["c_phone"], :description=>"Company" )
        end

        unless rec["c_fax"].empty?
          this_callable.phone_numbers.build( :dial_code=>rec["c_fax"], :description=>"Fax" )
        end

        unless rec["c_home_phone"].empty?
          this_callable.phone_numbers.build( :dial_code=>rec["c_home_phone"], :description=>"Home?" )
        end

        unless rec["c_mobile_phone"].empty?
          this_callable.phone_numbers.build( :dial_code=>rec["c_mobile_phone"], :description=>"Mobile" )
        end
  end

  def self.org_site_name( rec )
    co = rec["c_company"]
    co = co.blank? ? "Unknown":co
    co = co + "-" + (rec["c_city"].blank? ? rec["c_addr1"]:rec["c_city"])
  end

  def self.split_person_name( n )
    v = n.split(" ")
    if v.length == 2
      [v[0],v[1]]
    else
      if v[0].nil? 
        v0 = ""
      else
        v0 = v[0]
      end
      if v[1].nil?
        v1 = ""
      else
        v1=v[1]
      end
      [v0 + " " + v1, v[2]]
    end
  end

  def self.merge_address( s, addr, func )
puts "s.name: " + s.name
      s.addresses.each do |a|
        if a.compare( addr ) 
          a = a.merge( addr )
          a.function = func
          a.save
          return s
        end
      end
      nil
  end

  def self.assign_email( p, rec )
    unless rec["c_email"].empty?
      p.email_addresses.build( :url=>rec["c_email"] )
    end
  end

  def self.populate_site_data( p, rec ) # p is Party

    new_addr = compose_address( rec )
    site = Site.new
 
puts "populate: " + p.display_name
    found = false
    p.sites.each do |s|
      site = merge_address( s, new_addr, "Mailing" )
      found = !site.nil?
      break if found
    end

    if !found
      site = Site.new(:name=>org_site_name(rec))
      site.save
      sa = p.site_associations.build
      sa.site_id = site.id
      sa.description = "Office"
      sa.save
      new_addr = site.addresses.build
      new_addr.function = "Mailing"
      assign_address( new_addr, rec )
      new_addr.save
    end
    site.save
    site
  end

  def self.split_fn_ln( rec )

    if (rec["c_first_name"].blank? and rec["c_last_name"].blank? )
      if rec["c_person"].blank?
        if rec["c_name"].blank?
          if rec["c_city"].blank?
            rec.each_key do |k|
              unless rec[k].blank?
                unless rec[k] == "0"
                  print k + "=>" + rec[k] + " "
                end
              end
            end
            fn = "NoFirstName"
            ln = "NoLastName"
          else
            fn = "Unknown"
            ln = rec["c_city"] + "-Customer"
          end
#          puts rec.inspect
#          raise "# ERROR - we shouldn't be here!"
        else
          (fn,ln)=split_person_name(rec["c_name"])
        end
      else
        (fn,ln)=split_person_name(rec["c_person"])
      end
    else
      fn = rec["c_first_name"]
      ln = rec["c_last_name"]
    end
    [(fn.nil? ? "":fn).capitalize,(ln.nil? ? "":ln).capitalize]
  end

  def self.dry_run
    @@other.each do |rec|
      (fn,ln) = split_fn_ln( rec )
puts fn + ", " + ln
    end
    nil
  end

  def self.import_data
    site = Site.new
#
# Assuming here that if employee is not found then employer does not exists either
#
    employee = Role.find_by_name("Employee")
    if employee.nil?
      employee = Role.new(:name=>"Employee")
      employee.save
    end

    employer = Role.find_by_name("Employer")
    if employer == nil
      employer = Role.new(:name=>"Employer")
      employer.save
    end

    employer.correlative_id=employee.id
    employee.correlative_id=employer.id
    employee.save
    employer.save
     
    cid = PrivateIdDefinition.find_by_name("cid")
    if( cid.nil? )
      lhiorg = Organization.create
      lhiorg.names.build( "LHI" )
      lhiorg.save
      cid = PrivateIdDefinition.new
      cid.party_id = lhiorg.id
      cid.name = "cid"
      cid.save
    else
puts "FOUND cid"
    end 
    
    cid = PrivateIdDefinition.first

    @@person.each do |rec|

      (fn,ln) = split_fn_ln( rec )

puts "Populating Person: fn: " + fn + " ln: " + ln

      site = Site.new
      site.name = fn + " " + "-Home"

      unless addr_is_empty( rec )
        new_addr = site.addresses.build
        assign_address( new_addr, rec )
        new_addr.function = "Mailing"
      end

      unless rec["c_phone"].empty?
        site.phone_numbers.build( :dial_code=>rec["c_phone"], :description=>"Home" )
      end

      unless rec["c_fax"].empty?
        site.phone_numbers.build( :dial_code=>rec["c_fax"], :description=>"Fax" )
      end
      site.save

      p = Person.new
      p.names.build( :surname=>ln, :rest_of_name=>fn)
      p.external_identifiers.build( :private_id_definition_id=> cid.id, :identifier=>rec["c_id"] )

      assign_email( p, rec )

      unless rec["c_notes"].empty?
        p.comments.build( :text => rec["c_notes"] )
      end

      unless rec["c_home_phone"].empty?
        p.phone_numbers.build( :dial_code=>rec["c_home_phone"], :description=>"Home" )
      end

      unless rec["c_mobile_phone"].empty?
        p.phone_numbers.build( :dial_code=>rec["c_mobile_phone"], :description=>"Mobile" )
      end

      sa = p.site_associations.build(:description=>"Home")
      sa.site_id = site.id
      sa.save
      p.save

      nil 
    end

#    @@org[1..1000].each do |orec|
    @@org.each do |orec|

      if orec["c_company"].blank?
        c_co = "Unknown " + orec["c_city"] + "-customer"
      else
        c_co = orec["c_company"]
      end

      #check to see if there is already a org with the same name
      if (pn = PartyName.find_by_surname(c_co)).nil?
        o = Organization.new
        o.names.build( :surname=>c_co)
      else
        o = Party.find(pn.party_id)
        puts "DUPLICATE.1:" + (c_co.nil? ? "How can this be?":c_co)
      end

      o.external_identifiers.build( :private_id_definition_id=> cid.id, :identifier=>orec["c_id"] )

      if addr_is_empty( orec ) and pn.nil?
      else
        site=populate_site_data( o, orec )
      end

      callable_assign( site, orec )
      assign_email( o, orec )
        
      unless orec["c_notes"].empty?
        o.comments.build( :text => orec["c_notes"] )
      end

      o.save

    end

    @@org_person.each do |op|
#    @@org_person[1..1000].each do |op|

      (fn,ln) = split_fn_ln( op )
      site = nil

      c_co = op["c_company"]

      if c_co.nil?
        puts "No Company Info for: " + fn + " " + ln
      else
        if ( pn = PartyName.find_by_surname(c_co)).nil?
          o = Organization.new
          o.names.build( :surname=>c_co)
          o.save
        else
          o = Party.find(pn.party_id)
        end
      end

      assign_email( o, op )

      if addr_is_empty( op )
        if o.sites.count == 0 
          site=o.sites.build(:name=>"Office")
        else
          site=populate_site_data( o, op )
        end 
      end 

      unless op["c_phone"].empty?
        site.phone_numbers.build( :dial_code=>op["c_phone"], :description=>"Company" )
      end

      unless op["c_fax"].empty?
        site.phone_numbers.build( :dial_code=>op["c_fax"], :description=>"Fax" )
      end
      site.save

puts "fn: " + fn + " ln: " + ln

      p = Person.new
      p.names.build( :surname=>ln, :rest_of_name=>fn)
      p.external_identifiers.build( :private_id_definition_id=> cid.id, :identifier=>op["c_id"] )

      unless op["c_notes"].empty?
        p.comments.build( :text => op["c_notes"] )
      end

      unless op["c_home_phone"].empty?
        p.phone_numbers.build( :dial_code=>op["c_home_phone"], :description=>"Home?" )
      end

      unless op["c_mobile_phone"].empty?
        p.phone_numbers.build( :dial_code=>op["c_mobile_phone"], :description=>"Mobile" )
      end

      sa = p.site_associations.build(:description=>"Office")
      sa.site_id = site.id
      sa.save
      p.save

      employee_relationship = p.relationships.build( :role_id=>employee.id, :begin_date=>"1/1/1970" )
      employee_relationship.save
      employer_relationship = o.relationships.build( :role_id=>employer.id, :begin_date=>"1/1/1970" )
      employer_relationship.save
      employer_relationship.counterpart_id = employee_relationship.id
      employee_relationship.counterpart_id = employer_relationship.id
      employee_relationship.save
      employer_relationship.save
      p.save

    end
    nil 
  end

  def self.clear_database
    puts "Use: bundle exec rake db:drop; bundle exec rake db:migrate"
    puts " to clear the database.  Much quicker."
  end

end

