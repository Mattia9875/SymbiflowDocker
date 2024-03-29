import os, logging, shutil
from fpga.project import Project

# configure logging
logging.basicConfig()

# get the args from the env variables
args = {
    'part': os.getenv('BOARD_MODEL'),
    'topfilename': os.getenv('TOP_FILE'),
    'prjdir': os.getenv('PRJ_DIR'),
    'mode': int(os.getenv('MODE'))
}

# cd into the dir
os.chdir(args['prjdir'])
if (args['mode'] != 1):
    shutil.rmtree(args['prjdir'] + "/build", ignore_errors=True)


# configure the project
prj = Project('symbiflow')
prj.set_outdir(args['prjdir'] + "/build")

# part selection
if (args['part'] == "xc7a50t"):
    prj.set_part('xc7a35tcsg324-1')
elif (args['part'] == "xc7a100t"):
    prj.set_part('xc7a100tcsg324-1')
elif (args['part'] == "xc7z010"):
    prj.set_part('xc7z010clg400-1')
elif (args['part'] == "xc7a200t"):
    prj.set_part('xc7a200tsbg484-1')
else:
    prj.set_part('xc7a35tcsg324-1')

# add files to the project
dir_list = os.listdir(args['prjdir'])
for file_name in dir_list:
    prj.add_files(file_name)

# set top level entity
prj.set_top(args['topfilename'][:-2])

if (args['mode'] == 0):
    # generate the project
    prj.generate()
    os.system("exit")
elif (args['mode'] == 1):
    # cd into build and upload the design
    os.chdir(args['prjdir'] + "/build")
    os.system("xc3sprog -c nexys4 symbiflow.bit")
    os.system("exit")
else:
    # generate the project
    prj.generate()
    # cd into build and upload the design
    os.chdir(args['prjdir'] + "/build")
    os.system("xc3sprog -c nexys4 symbiflow.bit")
    os.system("exit")
