# Arugment Parser

Scripts that make argument parsing easy. With only two lines in a python or shell script you can easily parse arguments given to the program. I don't really use other languages, so unless I change my ways, this will be it!

Each file has its own help which prints when the file is executed.
```
#########################################
#  arg_parser.py by Jeffery Vahrenkamp  #
#########################################

usage:

Include "from arg_parser import get_flags" at the top of your script, and make sure 
the program is in your python path or the folder of your program.

The "get_flags" function is used to define flags to be parsed by the script.
It returns a dictionary with the variable name associated with the items.
This is passed to the python program by adding "globals().update( ) around the function.
Defining Flags:
	-Anything before a flag will be saved under the variable unflagged
	-Mandatory flags use the format variable=flag  example: Mandatory_argument=-m
	-Optional flags use the format variable~flag  example: Optional_argument~-o
Help Messages:
	-If a usage message is desired to be printed when mandatory flags are
	 create a string the be displayed and make it the second argument for 
	 get_flags

Example.py script:
       	
	from arg_parser import get_flags
      	usage="usage: Do this and not that!"
      	globals().update(get_flags("optional~-o mandatory=-m",usage))
       	print "optional="+optional
       	print "mandatory="+mandatory
       	print "unflagged="+unflagged
---------------------------------------------
$:python Example.py no_flag -o optional1 option2 -m this_is_mandatory
Output:
        optional=optional1 option2
        mandatory=this_is_mandatory
        unflagged=no_flag



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

