#!/bin/bash
# NOTE: not actually usable, while it's possible to bind it to a key, and it'd succesfully toggle the different monitor outputs,
# the toggle will fail when the monitor connected to the PC the script is ran from isn't the one that's currently being toggled.
# This is because of the way ddcutil works, so i don't think i can get around it

echo "mon_id stored in /tmp BEFORE -> $(cat /tmp/mon_id)"
ddc="$(ddcutil capabilities | awk "/Feature: [0-9]{1,} \(Input Source\)/{p=1;print;next} p&&/^[ ]{1,}F/{p=0};p" | grep -v Values | tr -d ':')"
mon_input_value="0x$(echo "$ddc" | head -n 1 | grep -oE "[0-9]{1,}")"
declare -A monitor_inputs

while read -r m_id m_input
do
	monitor_inputs["$m_input"]="0x$m_id"
done < <(echo "$ddc" | tail -n +2)

! [[ -e /tmp/mon_id ]] && echo "${monitor_inputs['DisplayPort-1']}" > /tmp/mon_id
current_id="$(cat /tmp/mon_id)"

let idx=0; for id_x in ${monitor_inputs[@]}; do
	if [[ "$id_x" == "$current_id" ]]; then
		next_idx=$(( ( idx + 1 ) % ${#monitor_inputs[@]} ))
		let idx2=0; for id_y in ${monitor_inputs[@]}; do
			[[ $idx2 -eq $next_idx ]]  && echo "$id_y" > /tmp/mon_id && break
			(( idx2++ ))
		done
		break
	fi
	(( idx++ ))
done

echo "mon_id stored in /tmp AFTER -> $(cat /tmp/mon_id)"
ddcutil setvcp "$mon_input_value" "$(cat /tmp/mon_id)"
