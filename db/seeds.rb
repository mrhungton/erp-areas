ActiveRecord::Base.logger = nil

# Create countries
if Erp::Areas::Country.where(code: 'vn', name: 'Việt Nam').empty?
  vn = Erp::Areas::Country.create(code: 'vn', name: 'Việt Nam')
else
  vn = Erp::Areas::Country.find_by_code(code: 'vn')
end

puts "Total #{Erp::Areas::Country.count} countries in the table"

# =============
# Import states
xlsx_states = Roo::Spreadsheet.open('engines/areas/database/danh_sach_cap_tinh_gso_19_12_2020.xlsx')
# Read excel file. sheet tabs loop
xlsx_states.each_with_pagename do |name, sheet|
  count = 0
  
  sheet.each_row_streaming do |row|
    if row[1].value == vn.id # kiem tra xem co phai ma quoc gia la cua Viet Nam khong (ID Viet Nam vua tao o tren)
      if Erp::Areas::State.where(name: "#{row[0].value}", country_id: vn.id).empty? # kiem tra xem ten tinh/thanhpho da ton tai chua /neu chua thi tao
        st = Erp::Areas::State.create(
          name: row[0].value,
          country_id: row[1].value
        )
        count += 1
        puts row[0].value
      end
    end    
  end
  puts '-----'
  puts "#{count} states (Vietnam) have been imported"
  puts "Total #{Erp::Areas::State.count} states in the table"
end

# ================
# Import districts      
xlsx_districts = Roo::Spreadsheet.open('engines/areas/database/danh_sach_cap_huyen_gso_19_12_2020.xlsx')
# Read excel file. sheet tabs loop
xlsx_districts.each_with_pagename do |name, sheet|
  thutu_huyen = 0
  sheet.each_row_streaming do |row|
    if Erp::Areas::District.where('erp_areas_districts.name = ? AND erp_areas_districts.state_id = ? ', row[0].value, row[1].value).empty? # kiem tra xem ten quan/huyen da ton tai chua /neu chua thi tao
      Erp::Areas::District.create(
        name: row[0].value,
        state_id: row[1].value
      )
      thutu_huyen += 1
      puts row[0].value
    end
  end
  puts '-----'
  puts "#{thutu_huyen} districts (Vietnam) have been imported"
  puts "Total #{Erp::Areas::District.count} districts in the table"
end