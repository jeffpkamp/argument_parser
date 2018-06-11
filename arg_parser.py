from sys import argv
import re

def get_flags(keys,usage="No Usage message included"):
	keys=keys.split(" ")
	flag={}
	optional_keys={}
	mandatory_keys={}
	working="--unflagged"
	flag[working]=""
	keys=list(keys)+argv[1:]
	for x in keys:
		if "~" in x:
			optional_keys[x.split("~")[0]]=x.split("~")[1]
		elif "=" in x:
			mandatory_keys[x.split("=")[0]]=x.split("=")[1]
		elif re.search("^-",x):
			flag[x]=""
			working=x
		else:
			flag[working]+=" "+x
	quit=0
	for x in flag:
		flag[x]=flag[x].lstrip(" ")
	for x in mandatory_keys:
		if mandatory_keys[x] not in flag:
			quit+=1
			if quit==1:
				print "\033[91m\nThe following Errors occured!\033[0m" 
			print "The "+mandatory_keys[x]+" flag is required!"
		else:
			mandatory_keys[x]=mandatory_keys[x].lstrip(" ");
			globals()[x]=flag[mandatory_keys[x]]
	if (quit > 0 ):
		from sys import stderr
		stderr.write(usage+"\n")
		stderr.close()
		exit()
	for x in optional_keys:
		if optional_keys[x] not in flag:
			continue
		flag[optional_keys[x]].lstrip(" ")
		globals()[x]=flag[optional_keys[x]]
	flag["--unflagged"].lstrip()
	re_dic={}
	for x in mandatory_keys:
		re_dic[x]=flag[mandatory_keys[x]]
	for x in optional_keys:
		if optional_keys[x] in flag:
			re_dic[x]=flag[optional_keys[x]]
	if flag["--unflagged"]:
		re_dic['unflagged']=flag["--unflagged"]
	return re_dic
		
if __name__ == "__main__":
	print """
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
"""
