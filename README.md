# Powershell License Manager

This script aims to modify the sub license for users in O365. It is useful for removing access to certain services for certain users. For example I have used it in a school to remove access to Email accounts for students in O365.

# How To Use

First note I haven't really tested this script all that much. I've used in on multiple occasions but still proceed with caution and use at you own risk. As I advise with all Powershell scripts you probably want to go through it and understand the whole thing before you run it.

You'll need to make sure you're connected to your O365 instance before running the script.

The key things you might want to change are :

$to_disable_arr this defines the products you want to disable - these have particular names which you can find through Powershell. I often manually modify a user in the GUI to have the sub licences  I want them to have and then compare to a fully enabled user to get the list I need.

users.csv - This file is exported from the O365 admin interface. I keep meaning to automate this step but have yet to get round to it.
