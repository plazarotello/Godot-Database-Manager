extends Node

enum {
	e_column_type_int = 0,
	e_column_type_string
}

class cProp:
	var m_id
	var m_type
	var m_name
	func set_id(id):
		m_id = id
	func get_id():
		return m_id
	func set_type(type):
		m_type = type
	func get_type():
		return m_type
	func set_name(name):
		m_name = name
	func get_name():
		return m_name

class cData:
	var m_prop_id = -1
	var m_row_idx = -1
	var m_data = ""
	func set_prop_id(id):
		m_prop_id = id
	func get_prop_id():
		return m_prop_id
	func set_row_idx(idx):
		m_row_idx = idx
	func get_row_idx():
		return m_row_idx
	func set_data(data):
		m_data = data
	func get_data():
		return m_data

class cTable:
	var m_name = ""
	var m_props = []
	var m_data = []
	var m_rows_count = 0
	func set_name(name):
		m_name = name
	func get_name():
		return m_name
	func add_prop(prop_id, prop_type, prop_name):
		var prop = cProp.new()
		prop.set_id(prop_id)
		prop.set_type(prop_type)
		prop.set_name(prop_name)
		m_props.push_back(prop)
	func change_prop(prop_id, prop_type, prop_name):
		for idx in range(0, m_props.size()):
			if(m_props[idx].get_id() == prop_id):
				m_props[idx].set_type(prop_type)
				m_props[idx].set_name(prop_name)
				break
	func delete_prop(prop_id):
		var prop_found = false
		for idx in range(0, m_props.size()):
			if(m_props[idx].get_id() == prop_id):
				m_props.remove(idx)
				prop_found = true
				break
		if(!prop_found):
			print("ERROR: cTable::delete_prop( " + str(prop_id) + " ) - property not found !")
			return
		# remove the data
		for idx in range(m_data.size() - 1, 0, -1):
			if(m_data[idx].get_prop_id() == prop_id):
				m_data.remove(idx)
		# recreate properties' ids
		for idx in range(0, m_props.size()):
			m_props[idx].set_id(idx)
		# recreate properties' ids from data
		for idx in range(0, m_data.size()):
			var p_id = m_data[idx].get_prop_id()
			if(p_id > prop_id):
				m_data[idx].set_prop_id(p_id + 1)
	func get_props_count():
		return m_props.size()
	func get_prop_id(idx):
		if(idx < 0 || idx > m_props.size()-1):
			print("ERROR: cTable::get_prop_id( " + str(idx) + " ) - max props: " + str(m_props.size()))
			return 0
		return m_props[idx].get_id()
	func get_prop_type(idx):
		if(idx < 0 || idx > m_props.size()-1):
			print("ERROR: cTable::get_prop_type( " + str(idx) + " ) - max props: " + str(m_props.size()))
			return 0
		return m_props[idx].get_type()
	func get_prop_name(idx):
		if(idx < 0 || idx > m_props.size()-1):
			print("ERROR: cTable::get_prop_name( " + str(idx) + " ) - max props: " + str(m_props.size()))
			return ""
		return m_props[idx].get_name()
	func add_blank_row():
		for idx in range(0, m_props.size()):
			var data = cData.new()
			data.set_prop_id(m_props[idx].get_id())
			data.set_row_idx(m_rows_count)
			m_data.push_back(data)
		m_rows_count += 1
	func remove_row(row_idx):
		for idx in range(m_data.size()-1, 0, -1):
			if(m_data[idx].get_row_idx() == row_idx):
				m_data[idx].remove(idx)
				m_rows_count -= 1
	func get_rows_count():
		return m_rows_count
	func update_data(prop_id, row_idx, data):
		# print("#1: cTable::update_data( " + str(prop_id) + ", " + str(row_idx) + ", " + data + " )")
		for idx in range(0, m_data.size()):
			# print("checking ( " + str(m_data[idx].get_row_idx()) + ", " + str(m_data[idx].get_prop_id()) + " )")
			if(m_data[idx].get_row_idx() == row_idx && m_data[idx].get_prop_id() == prop_id):
				# print("#2: cTable::update_data( " + str(prop_id) + ", " + str(row_idx) + ", " + data + " )")
				m_data[idx].set_data(data)
				break
	func get_data_size():
		return m_data.size()
	func get_data_at(idx):
		if(idx < 0 || idx >= m_data.size()):
			print("ERROR: cTable::get_data_at( " + str(idx) + " ) - max data size: " + str(m_data.size()))
			return ""
		return m_data[idx].get_data()
	func get_data(prop_id, row_idx):
		for idx in range(m_data.size()-1, 0, -1):
			if(m_data[idx].get_row_idx() == row_idx && m_data[idx].get_prop_id() == prop_id):
				return m_data[idx].get_data()
		print("ERROR: cTable::get_data( " + str(prop_id) + ", " + str(row_idx) +  " )")
		return ""
	func get_data_by_prop_id(prop_id):
		var data = []
		for idx in range(0, m_data.size()):
			if(m_data[idx].get_prop_id() == prop_id):
				data.push_back(m_data[idx])
		if(data.size() == 0):
			print("ERROR: cTable::get_data_by_prop_id( " + str(prop_id) + " )")
		return data
	func get_data_by_prop_name(prop_name):
		var prop_id = -1
		for idx in range(0, m_props.size()):
			if(m_props[idx].get_name() == prop_name):
				prop_id = m_props[idx].get_id()
				break
		if(prop_id == -1):
			print("ERROR: cTable::get_data_by_prop_name( " + prop_name + " )")
			return []
		return get_data_by_prop_id(prop_id)
	func get_data_by_row_idx(row_idx):
		var data = []
		for idx in range(0, m_data.size()):
			if(m_data[idx].get_row_idx() == row_idx):
				data.push_back(m_data[idx])
		if(data.size() == -1):
			print("ERROR: cTable::get_data_by_row_idx( " + str(row_idx) + " )")
		return data
	# example:
	# select * from users where user_id = 1
	# get_row_by_data("id", 1)
	func get_row_by_data(prop_name, data_value):
		var prop_id = -1
		for idx in range(0, m_props.size()):
			if(m_props[idx].get_name() == prop_name):
				prop_id = m_props[idx].get_id()
				break
		var row_idx = -1
		for idx in range(0, m_data.size()):
			if(m_data[idx].get_prop_id() == prop_id && m_data[idx].get_data() == data_value):
				row_idx = m_data[idx].get_row_idx()
				break
		var row = []
		for idx in range(0, m_data.size()):
			if(m_data[idx].get_row_idx() == row_idx):
				row.push_back(m_data[idx])
		if(row.size() == -1):
			print("ERROR: cTable::get_row_by_data( " + prop_name + ", " + str(data_value) + " )")
		return row
