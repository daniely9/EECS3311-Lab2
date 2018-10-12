note
	description: "A DATABASE ADT mapping from keys to two kinds of values"
	author: "Jackie Wang and You"
	date: "$Date$"
	revision: "$Revision$"

class
	DATABASE[V1, V2, K]
inherit
	ITERABLE[TUPLE[K, V1, V2]]

create
	make

feature {EXAMPLE_DATABASE_TESTS} -- Do not modify this export status!
	-- You are required to implement all database features using these three attributes.
	keys: LINKED_LIST[K]
	values_1: ARRAY[V1]
	values_2: LINKED_LIST[V2]

feature -- feature(s) required by ITERABLE
	-- Your Task
	-- See test_iterable_databse and test_iteration_cursor in EXAMPLE_DATABASE_TESTS.
	-- As soon as you make the current class iterable,
	-- define the necessary feature(s) here.
	new_cursor : ITERATION_CURSOR[TUPLE[K, V1, V2]]
		local
			cursor : TUPLE_ITERATION_CURSOR[K, V1, V2]
		do
			create cursor.make (keys, values_1, values_2)
			Result := cursor
		end

feature -- alternative iteration cursor
	-- Your Task
	-- See test_another_cursor in EXAMPLE_DATABASE_TESTS.
	-- A feature 'another_cursor' is expected to be defined here.
	another_cursor : ITERATION_CURSOR[RECORD[V1, V2, K]]
		local
			cursor2 : RECORD_ITERATION_CURSOR[V1, V2, K]
		do
			create cursor2.make (values_1, values_2, keys)
			Result := cursor2
		end


feature -- Constructor
	make
			-- Initialize an empty database.
		do
			-- Your Task
			create keys.make
			create values_1.make_empty
			create values_2.make
			keys.compare_objects
			values_1.compare_objects
			values_2.compare_objects


		ensure
			empty_database: -- Your Task
				True
			-- Do not modify the following three postconditions.
			object_equality_for_keys:
				keys.object_comparison
			object_equality_for_values_1:
				values_1.object_comparison
			object_equality_for_values_2:
				values_2.object_comparison
		end

feature -- Commands

	add_record (v1: V1; v2: V2; k: K)
			-- Add a new record into current database.
		require
			non_existing_key: -- Your Task
				not current.exists (k)

		do
			-- Your Task
			keys.extend (k)
			values_1.force (v1, values_1.count + 1)
			values_2.extend (v2)

		ensure
			record_added: -- Your Task
				-- Hint: At least a record in current database.
				-- has its key 'k', value 1 'v1', and value 2 'v2'.
			across current as i all
				current.exists (k) and values_1.at (count) ~ v1 and values_2.at (count) ~ v2
			end

		end

	remove_record (k: K)
			-- Remove a record from current database.s
		require
			existing_key: -- Your Task
				current.exists (k)
		local
			tmp_array : ARRAY[V1]
			counter : INTEGER
		do
			-- Your Task
			counter := 1
			create tmp_array.make_empty

			across keys as i loop
				if(i.item = k)
					then
					keys.go_i_th (i.cursor_index)
					keys.remove
					values_2.go_i_th (i.cursor_index)
					values_2.remove
					across values_1 as j loop
						if(i.cursor_index /= j.cursor_index)
						then
						tmp_array.force (j.item, counter)
						counter := counter  + 1
						end

					end

				end
			end
			values_1.copy (tmp_array)


		ensure
			database_count_decremented: -- Your Task
				old count /= Current.count
			key_removed: -- Your Task
				not	current.exists (k)
		end

feature -- Queries

	count: INTEGER
			-- Number of records in database.
		local
		counter : INTEGER
		do
			-- Your Task
			counter := 0
			across current as i loop
			counter := counter + 1
			 end
			 Result := counter
		ensure
			correct_result: -- Your Task
				True
		end

	exists (k: K): BOOLEAN
			-- Does key 'k' exist in the database?
		local

		do
			-- Your Task
			Result := across keys as i some
				i.item ~ k
			 end

		ensure
			correct_result: -- Your Task
				across keys as index some
					index.item = k
				 end
		end


	get_keys (v1: V1; v2: V2): ITERABLE[K]
			-- Keys that are associated with values 'v1' and 'v2'.
		local
		return : LINKED_LIST[K]
		do	-- Your Task
			create return.make

			across keys as i loop
				if values_1.at (i.cursor_index) ~ v1 and values_2.at (i.cursor_index) ~ v2
				then
					return.extend (i.item)
				end
			end
			Result := return
		ensure
			result_contains_correct_keys_only: -- Your Task
				-- Hint: Each key in Result has its associated values 'v1' and 'v2'.
				across Result as i all
					values_1.at (keys.index_of (i.item, 1)) ~ v1 and values_2.at (keys.index_of (i.item, 1)) ~ v2
				end
			correct_keys_are_in_result: -- Your Task
				-- Hint: Each record with values 'v1' and 'v2' has its key included in Result.
				-- Notice that Result is ITERABLE and does not support the feature 'has',
				-- Use the appropriate across expression instead.
				across Current as cur all
					(cur.item[2] ~ v1 and cur.item[3] ~ v2) implies not (across Result as res all cur.item[1] ~ res.item end)
				end
		end

invariant
	unique_keys: -- Your Task
		-- Hint: No two keys are equal to each other.
		across keys as i all
			across keys as j all
				(i.cursor_index /= j.cursor_index) implies (i.item /= j.item)
			end
		end
	-- Do not modify the following three class invariants.
	implementation_contraint:
		values_1.lower = 1
	consistent_keys_values_counts:
		keys.count = values_1.count
		and
		keys.count = values_2.count
	consistent_imp_adt_counts:
		keys.count = count
end
