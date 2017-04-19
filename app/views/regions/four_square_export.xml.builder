xml.instruct! :xml, version: '1.0'
xml.data do
  xml.regions do
    @regions.each do |region|
      xml.region do
        xml.name region.name
        xml.fullName region.full_name
        xml.lat region.lat
        xml.lon region.lon
        xml.locations do
          region.locations.each do |location|
            xml.location do
              xml.name location.name
              xml.lat location.lat
              xml.lon location.lon
              xml.street location.street
              xml.city location.city
              xml.state location.state
              xml.zip location.zip
              xml.phone location.phone
              xml.numMachines location.machines.size
              xml.machines do
                location.machines.sort_by(&:name).each do |machine|
                  xml.machine do
                    xml.name machine.name
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
