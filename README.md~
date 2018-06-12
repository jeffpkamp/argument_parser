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
# arg_parser.sh by Jeffery Vahrenkamp #
#######################################

Usage:

        Include "source ~u6004424/bin/arg_parser.sh" at the top of the script
        the "get_flags" function is used to define flags to be parsed by script

        Defining Flags:
                -Anything before a flag will be saved under the variable $unflagged
                -Mandatory flags use the format variable=flag  example: Mandatory_argument=-m
                -Optional flags use the format variable~flag  example: Optional_argument~-o

        Help Messages:
                -If a usage message is desired to be printed when mandatory flags are
                    not present create a function called usage which echos your message
                -Usage function must be defined before get_flags function call!
                -NOTE:The -h flag is reserved for calling the usage function without error messages!

Example.sh script:
       source ~u6004424/bin/arg_parser.sh

       usage () {
               echo -e "this is a usage or help message"
       }

       get_flags optional~-o mandatory=-m

       echo optional=$optional
       echo mandatory=$mandatory
       echo unflagged=$unflagged

---------------------------------------------
$:bash Example.sh no_flag -o optional1 option2 -m this_is_mandatory

Output:
        optional=optional1 option2
        mandatory=this_is_mandatory
        unflagged=no_flag
```
