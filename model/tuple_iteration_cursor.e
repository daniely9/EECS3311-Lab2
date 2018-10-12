note
	description: "Summary description for {TUPLE_ITERATION_CURSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TUPLE_ITERATION_CURSOR[K, V1, V2]

inherit
	ITERATION_CURSOR [TUPLE[K, V1, V2]]

create

make

feature -- Constuctor

	make (k: LINKED_LIST[K]; v1: ARRAY[V1]; v2: LINKED_LIST[V2])
		do
			keys := K
			values_1 := V1
			values_2 := V2

			index := values_1.lower
		end
feature {NONE}
	values_1 : ARRAY[V1]
	values_2 : LINKED_LIST[V2]
	keys : LINKED_LIST[K]
	index : INTEGER

feature --

	item : TUPLE[K, V1, V2]
		local
			k : K
			v1 : V1
			v2 : V2
		do
			k := keys[index]
			v1 := values_1[index]
			v2 := values_2[index]
			create Result
			Result := [k, v1, v2]
		end
	after : BOOLEAN
		do
			Result := index > values_1.upper
		end

	forth
		do
			index := index + 1
		end
end


--delta hacks
--westorn hack
