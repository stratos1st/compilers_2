from subprocess import PIPE, run
from os import listdir, path, system, stat
from sys import exit

assert path.exists("./tests")
for f in listdir("./tests"):
  ext = ".txt"
  if f.endswith(ext):
    full_path = "./tests/" + f
    expected_output_file = full_path[:-len(ext)] + ".out"
    assert path.exists(expected_output_file)
    myinput = open(full_path)
    p = run(["java", "calculator"], stdin=myinput, stdout = PIPE, stderr=PIPE)
    out = (p.stdout + p.stderr).decode('ascii')
    open("curr_out", "w+").write(out)
    system("diff curr_out " + expected_output_file + " > curr_diff")
    if stat("curr_diff").st_size != 0:
      print("MISMATCH IN:", full_path)
      exit()
    else:
      system("rm curr_diff curr_out")
