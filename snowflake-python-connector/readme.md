# Step-1
# ----------------
# lets check the python version, it must be higher than 3.6

# python3 --version


# Step-2
# ----------------
# Creating a virtual environment and activating it

# python3 -m venv my_venv01
# source my_venv01/bin/activate

# Step-3
# ----------------
# Now my environment is ready and now I would like to install 
# Snowflake Connector for Python Library and that I will do it 
# using requirement.txt file. Lets review it

# pip install -r requirements.txt

# Validate if everything is installed correctly or not
# pip freeze > requirements01.txt

# Check if there is any older or oudated version 
# pip list --outdated

# if you want to upgrated, you can run pip -U
# pip install -U PackageName

# check missing dependencies
# python3 -m pip check