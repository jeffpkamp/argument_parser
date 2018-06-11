help_message () {
echo -e "\n#######################################\n# Arg_parser.sh by Jeffery Vahrenkamp #\n#######################################\n\nUsage:\n\
\n\
\tInclude \"source ~u6004424/bin/arg_parser.sh\" at the top of the script\n\
\tthe \"get_flags\" function is used to define flags to be parsed by script\n\

\tDefining Flags:\n\
\t\t-Anything before a flag will be saved under the variable "\$unflagged"\n\
\t\t-Mandatory flags use the format variable=flag  example: Mandatory_argument=-m\n\
\t\t-Optional flags use the format variable~flag  example: Optional_argument~-o\n\
\n\tHelp Messages:
\t\t-If a usage message is desired to be printed when mandatory flags are\n\
\t\t    not present create a function called usage which echos your message \n\
\t\t-Usage function must be defined before get_flags function call!\n\
\t\t\033[4m\033[32;1m-NOTE:The -h flag is reserved for calling the usage function without error messages!\033[0m\n\
\n\
Example.sh script:\n\
       source ~u6004424/bin/arg_parser.sh\n\
\n\
       usage () {\n\
               echo -e \"this is a usage or help message\"\n\
       }\n\
\n\
       get_flags optional~-o mandatory=-m \n\
\n\
       echo optional=\$optional\n\
       echo mandatory=\$mandatory\n\
       echo unflagged=\$unflagged\n\
\n\
---------------------------------------------\n\
\$:bash Example.sh no_flag -o optional1 option2 -m this_is_mandatory\n\
\nOutput:\n\
\toptional=optional1 option2\n\
\tmandatory=this_is_mandatory\n\
\tunflagged=no_flag\n\
"
}

__args=$@

[[ $__args == "" ]] && __args="-h"

get_flags () {
	eval $(echo $@ $__args | awk 'BEGIN{
			flag["--unflagged"]
			working="--unflagged"
		}
		{for (x=1;x<=NF;x++) {
			if ($x ~ "~") {
				split($x,out,"~")
				optional_keys[out[1]]=out[2]
			}
			else if ($x ~ "=") {
				split($x,out,"=") 
				mandatory_keys[out[1]]=out[2]
			}
			else if ($x~"^-") {
				flag[$x]
				working=$x
			}
			else flag[working]=flag[working]" "$x
		}
	}
	END{
		quit=0
		if ("-h" in flag) {
			print "[[ `type usage 2> /dev/null` =~ \"function\" ]] && usage || [[ -z $usage ]] || echo -e $usage; exit 1"
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
			}
		}
		if (quit > 0) {
			print "[[ `type usage 2> /dev/null` =~ \"function\" ]] && usage || [[ -z $usage ]] || echo -e $usage; exit 1"
			exit 1
		}
		for (x in optional_keys) {
			sub("^ ","",flag[optional_keys[x]])
			print x"=\""flag[optional_keys[x]]"\""
			}
		sub("^ ","",flag["--unflagged"])
		print "unflagged=\""flag["--unflagged"]"\""
	}')
}



[[ "${BASH_SOURCE[0]}" != "${0}" ]] || help_message


#usage:
# map flags to variable like this:
# Anything before a flag will be saved under the variable "$unflagged"
# mandatory flags use = : Mandatory_argument=-m
# optional flags use ~ : Optional_argument~-o 
# last argument must be $@!
# if a usage message is desired to be printed when mandator flags are not present create a function called usage which echos your message or create a variable called "usage" that contains your usage message
# Usage function/variable must be before get_flags function call!
#
#Example script: 
# 	source ~u6004424/bin/arg_parser.sh
#	
#	usage () {
#		echo -e "this is a ussage/help message"
#	{
#
# 	get_flags optional~-o mandatory=-m $@
#
# 	echo optional=$optional
# 	echo mandatory=$mandatory
# 	echo unflagged=$unflagged
#
#---------------------------------------------
#  Example.sh no_flag -o this_is_option -m this_is_mandatory 
#  Output:
# 	optional=this_is_optional
# 	mandatory=this_is_mandatory
# 	unflagged=no_flag
#
