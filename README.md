# hands_on_lab

create_assets.sh takes 3 options:

-u | --users   
This is the # of total lab users you want created and environments initialized

-d | --dbname  
This is the name of the base database you want created and then cloned for the n users created

-s | --secret  
This is the filename containing the AWS_KEY_ID and AWS_SECRET_KEY values to use when creating the inital stage in the base database.  Make sure file is readable by current user.

Example contents of file:
AWS_KEY_ID=xyz123abc456
AWS_SECRET_KEY=slfkjasdslljdsflksjdflj

To run:

./create_assets.sh --users 10 --dbname SALES_DEMO_DB --secret ~/aws_secret.txt  

You will be prompted to provide a password that will be used for each of the lab user accounts created.

This will produce a number of files in a newly created directory hands_on_assets

rsilva's MacBook Pro:hands_on_lab rsilva$ ls -l hands_on_assets/.  
total 32. 
-rw-r--r--  1 rsilva  wheel  13178 Apr 10 06:39   demo_setup.sql  
drwxr-xr-x  7 rsilva  wheel    224 Apr 10 06:39 user_1  
drwxr-xr-x  7 rsilva  wheel    224 Apr 10 06:39 user_10  
drwxr-xr-x  7 rsilva  wheel    224 Apr 10 06:39 user_2  
drwxr-xr-x  7 rsilva  wheel    224 Apr 10 06:39 user_3  
drwxr-xr-x  7 rsilva  wheel    224 Apr 10 06:39 user_4  
drwxr-xr-x  7 rsilva  wheel    224 Apr 10 06:39 user_5   
drwxr-xr-x  7 rsilva  wheel    224 Apr 10 06:39 user_6  
drwxr-xr-x  7 rsilva  wheel    224 Apr 10 06:39 user_7  
drwxr-xr-x  7 rsilva  wheel    224 Apr 10 06:39 user_8  
drwxr-xr-x  7 rsilva  wheel    224 Apr 10 06:39 user_9  

Run the SQL script demo_setup.sql in the desired environment.

Make the varous user_X directories available to the appropriate people for use during the labs.


If you want to use a different sequence of lab, simply replace the file setup/setup.sql with the necessary DDL to initialize your base environment; this environment will be cloned and permissioned such that each lab user has access to 1 and only 1 database.

Ensure the database DDL you provide uses DEMODB_NAME; the scripts provided will do a global replace at runtime - using the value provided for --dbname in its place.

The file setup/demo_setup.sql may also need to be replaced modified.  Currently, that script contains the necessary clone, create user, create role & grant statements to initialize the environment for each lab user.

