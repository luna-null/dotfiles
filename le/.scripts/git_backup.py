import shutil
import os

homeDir = os.environ.get("XDG_HOME_DIR")
print(homeDir)

files = [f[0] for f in os.walk(homeDir)]

print(files)
