#!/bin/bash

help_message () {
cat <<message

#######################################
# Arg_parser.sh by Jeffery Vahrenkamp #
#######################################

Usage:

Include "source FILE_LOCATION/arg_parser.sh" at the top of the script
the "get_flags" function is used to define flags to be parsed by script

Defining Flags:
	-Anything before a flag will be saved under the variable "\$unflagged"

	-Mandatory flags use the format variable=flag	
		- Example: Mandatory_argument=-m

	-Boolian flags use the format vaiable?flag
		- Example: Boolian_argument?-b
		- If -b is in the program aruments, its variable is set to 1

	-Optional flags use the format variable~flag:default  
		- Example: Optional_argument~-o:default_value
		- ;; in default values will be converted to space.
       		- Example: Optional~-o:val1;;val2;;val3 will become \$Optional=val1 val2 val3
	
	-To pass flags to end program add "pass_args" to get_flags
		- Any flags and associated variables passed to the program that are not defined in 
			get flags will be saved under the variable "\$passed_args" variable. 
	


Help Messages:
	-If a usage message is desired to be printed when mandatory flags are
		not present create a function called usage which echos your message
	-Usage function must be defined before get_flags function call!
		\033[4m\033[32;1m-NOTE:The -h flag is reserved for calling the usage function without error messages!\033[0m

Example.sh script:
       source FILE_LOCATION/arg_parser.sh

       usage () {
               cat << help_message
put your usage message here
formatting will be preserved

help_message
       }

       get_flags pass_args optional~-o noboolian?-nb boolian?-b optional_default~-d:MyOption optional_nodefault~-n mandatory=-m 

       echo optional=\$optional
       echo optional_default=\$optional_default
       echo optional_nodefault=\$optional_nodefault
       echo mandatory=\$mandatory
       echo unflagged=\$unflagged
	   echo boolian=\$boolian
	   echo noboolian=\$noboolian
       echo passed_args=\$passed_args

---------------------------------------------
\$:bash Example.sh no_flag -o optional1 option2 -m this_is_mandatory -b -z 1
Output:
	optional=optional1 option2
	optional_default=MyOption
	optional_nodefault=
	mandatory=this_is_mandatory
	unflagged=no_flag
	boolian=1
	noboolian=
	passed_args=-z 1

"
message
}

__args=$@


[[ $__args == "" ]] && __args="-h"


get_flags () {
	eval "$(echo $@ $__args | awk -v inargs="$__args" ' 
	BEGIN{
		flag["--unflagged"]
		working="--unflagged"
	}
	{
		for (x=1;x<=NF;x++) {
			if ($x ~ "~") {
				split($x,out,"[:~ ]")
				optional_keys[out[1]]=out[2]
				if (length(out)>2){
					gsub(";;"," ",out[3])
					default_value[out[1]]=out[3]
				}
			}
			else if ($x == "pass_args"){
					pass_args=1
			}
			else if ($x ~ "?") {
				split($x,out,"?")
				boolian_keys[out[1]]=out[2]
			}
			else if ($x ~ "=") {
				split($x,out,"=") 
				mandatory_keys[out[1]]=out[2]
			}
			else if ($x ~ "^-.+") {
				flag[$x]
				working=$x
			}
			else flag[working]=flag[working]" "$x
		}
	}
	END{
		quit=0
		if ("-h" in flag) {
			print "echo ;"
			print "[[ $(type -t usage 2> /dev/null) =~ function ]] && usage || [[ ! $usage ]] || echo -e $usage; exit 1"
			exit 0
		}
		for (x in mandatory_keys) {
			if (!(mandatory_keys[x] in flag)) {
				quit++
				if (quit==1) 
					print "echo -e \"\\nThe following errors occured!\";"
				print "echo -e \"The "mandatory_keys[x]" flag is Required!\";"
			}
			else {
				sub("^ ","",flag[mandatory_keys[x]])
				print x"=\""flag[mandatory_keys[x]]"\""
				delete flag[mandatory_keys[x]]
			}
		}
		if (quit > 0) {
			print "echo ;"
			print "[[ $(type -t usage 2> /dev/null) =~ function ]] && usage || [[ ! $usage ]] || echo -e $usage; exit 1"
			exit 1
		}
		for (x in optional_keys) {
			sub("^ ","",flag[optional_keys[x]])
			if (length(flag[optional_keys[x]]) > 0 || inargs ~ "^"optional_keys[x] ){
				print x"=\""flag[optional_keys[x]]"\""
				delete flag[optional_keys[x]]
			}
			else if (x in default_value) {
				print x"=\""default_value[x]"\""
				delete flag[optional_keys[x]]
			}
		}
		for (x in boolian_keys) {
			if (boolian_keys[x] in flag)
				print x"=1"
				delete flag[boolian_keys[x]]
		}
		sub("^ ","",flag["--unflagged"])
		if (length(flag["--unflagged"])>0) {
			print "unflagged=\""flag["--unflagged"]"\""
		}
		delete flag["--unflagged"]
		if (pass_args){
			for (x in flag){
				passed_args=passed_args" "x" "flag[x]
			}
			print "passed_args=\""passed_args"\""
		}
	}' || (echo -e "\n\nERROR:\narg_parsers get_flags failed\nChecking Awk version Information\n">/dev/stderr; awk -W version  1>/dev/stderr; echo -e "\n\n">/dev/stderr))"
}



[[ "${BASH_SOURCE[0]}" != "${0}" ]] || help_message


