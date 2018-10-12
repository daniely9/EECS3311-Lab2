 note
	description: "Summary description for {RECORD_ITERATION_CURSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RECORD_ITERATION_CURSOR [V1, V2, K]
inherit
	ITERATION_CURSOR [RECORD[V1, V2, K]]

create

make

feature -- Constuctor

	make (v1: ARRAY[V1]; v2: LINKED_LIST[V2]; k: LINKED_LIST[K])
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

	item : RECORD[V1, V2, K]

		do
			create Result.make(values_1[index], values_2.i_th (index), keys.i_th (index))
		end
	after : BOOLEAN
		do
			Result := index > values_1.upper
		end

	forth
		do
			index := index + 1
		end
invariant
	values_1.count = keys.count and
	values_2.count = keys.count
end
