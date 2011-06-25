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
    if rec["c_city"].empty?
      rec["c_company"] + "-" + rec["c_addr1"]
    else
      rec["c_company"] + "-" + rec["c_city"]
    end 
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
    
#    person.each do |p|
#      puts self.get_name_info(p)
#    end

    cid = PrivateIdDefinition.first

#    org[1..10].each do |orec|
#    org[11..20].each do |orec|
#    org[21..30].each do |orec|
#    org[31..100].each do |orec|
#    org[2000..3000].each do |orec|
#    org[1..1000].each do |orec|
    org.each do |orec|

      c_co = orec["c_company"]

      #check to see if there is already a org with the same name
      if (pn = PartyName.find_by_surname(c_co)).nil?
        o = Organization.new
        o.names.build( :surname=>c_co)
      else
        o = Party.find(pn.party_id)
        puts "DUPLICATE.1:" + c_co
      end

      o.external_identifiers.build( :private_id_definition_id=> cid.id, :identifier=>orec["c_id"] )

      if addr_is_empty( orec ) and pn.nil?
        callable_assign( o, orec )
      else
        # 
        # If this is a second or third occurance of this org name, create a new site
        #

        new_addr = compose_address( orec )
 
        found = false
        o.sites.each do |s|
#puts "h1"
          s.addresses.each do |a|
#puts "h2"
            if a.compare( new_addr ) 
#puts "h3"
puts a.serializable_hash
              a = a.merge( new_addr )
puts a.serializable_hash
              a.function = "Mailing"
              a.save
              callable_assign( s, orec )
              found = true
              break
            end
          end
          break if found
        end

        if !found
#puts "h4"
#puts address_hash( orec )
          site = o.sites.build( :name => org_site_name( orec) )
          new_addr = site.addresses.build
          new_addr.function = "Mailing"
          assign_address( new_addr, orec )
          new_addr.save
          callable_assign( site, orec )
          site.save
        end

      end
        
      unless orec["c_notes"].empty?
        o.comments.build( :text => orec["c_notes"] )
      end

      o.save

    end

    org_person.each do |op|
#    org_person[1..1000].each do |op|

      if (fn = op["c_first_name"]).nil? then fn = "First Name" end
      if (ln = op["c_last_name"]).nil? then ln = "Last Name" end

      if (op["c_first_name"].blank? and op["c_last_name"].blank? )
        if op["c_person"].blank?
          if op["c_name"].blank?
            (fn,ln)=split_person_name(op["c_name"])
          else
            #
            # ERROR - we shouldn't be here!
            #
          end
        else
          (fn,ln)=split_person_name(op["c_person"])
        end
      end

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
#          puts "DUPLICATE.2:" + c_co
        end
      end

      fn = fn.nil? ? "FirstName":fn
      ln = ln.nil? ? "LastName":ln

puts "fn: " + fn + " ln: " + ln

      p = Person.new
      p.names.build( :surname=>ln, :rest_of_name=>fn)
      p.external_identifiers.build( :private_id_definition_id=> cid.id, :identifier=>op["c_id"] )
      unless op["c_notes"].empty?
        p.comments.build( :text => op["c_notes"] )
      end
      callable_assign( p, op )
      p.save

    end
    

    puts "org_person: " + org_person.length.to_s
    puts "org:        " + org.length.to_s
    puts "person:     " + person.length.to_s
    puts "other:      " + other.length.to_s
    puts "all:        " + @@data.length.to_s
  end

  def self.clear_database
    ct = Party.all.length
    Party.all.collect(&:delete)
    puts "Party: " + ct.to_s + " records deleted."

    ct = PartyName.all.length
    PartyName.all.collect(&:delete)
    puts "PartyName: " + ct.to_s + " records deleted."

    ct = PhoneNumber.all.length
    PhoneNumber.all.collect(&:delete)
    puts "PhoneNumber: " + ct.to_s + " records deleted."

    ct = ExternalIdentifier.all.length
    ExternalIdentifier.all.collect(&:delete)
    puts "ExternalIdentifier: " + ct.to_s + " records deleted."

    ct = PrivateIdDefinition.all.length
    PrivateIdDefinition.all.collect(&:delete)
    puts "PrivateIdDefinition: " + ct.to_s + " records deleted."

    ct = Site.all.length
    Site.all.collect(&:delete)
    puts "Site: " + ct.to_s + " records deleted."

    ct = SiteAssociation.all.length
    SiteAssociation.all.collect(&:delete)
    puts "SiteAssociation: " + ct.to_s + " records deleted."

    ct = Address.all.length
    Address.all.collect(&:delete)
    puts "Address: " + ct.to_s + " records deleted."

    ct = Comment.all.length
    Comment.all.collect(&:delete)
    puts "Comment: " + ct.to_s + " records deleted."
  end

end

