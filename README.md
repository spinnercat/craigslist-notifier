## Craigslist Notifier

A quick script I wrote late one night to watch a Craigslist query and text me when new postings are made. Craigslist itself seems to only
do notifications through email, and I didn't want to miss some great deal because I was too slow in checking my email. I'm sure other
tools exist out there to do this same thing in a more robust way :)

## How to Use

Customize the top variables to fit your needs:
 * Get your query from Craigslist and insert `format=rss&` after the ?
 * Set your own custom path to the log file
 * Set the phone number you want to be texted at

Set it up to run regularly:
 * `$ crontab -e`
 * I have it run every 15 minutes, so my crontab looks like this: `*/15 * * * * /usr/bin/ruby /path/to/project/check.rb >> /path/to/out/out.txt 2>&1`
 * I redirect output to an out file that I can check for errors - good for cronjobs, otherwise you get mail.

## Future Improvements (that probably won't get done)

 * Use actual XML parser instead of the messy regex parsing I do
 * Use actual URI library for ruby instead of the system's curl
 * Generalize so user can input their own query instead of grabbing the url from Craigslist
 * When notifying, curl the listing to get the title and include it in the text message
 * Some system to delete old entries from the log file - the runtime will be O(n) in the length of the file

## Feedback

Feel free to use any way you want... I'd enjoy hearing if anybody out there ends up using it or makes any improvements!
