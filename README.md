# rc-checkins-rails


At RC, each week, we sign up for a different "check-in group" and meet with the group daily. Each of these 10-12 groups meets in a different room, often at a different time, and people often forget where and when they were supposed to meet.  The process is currently managed by making a new google spreadsheet each week, which is emailed out, and a chat bot that sends reminders to everyone on Zulip that it's time for (any) check-in.

My goal with this project is to create an automated system that allows you to sign up for a check-in with one to two clicks, and automates all of the reminders associated with the system, such as sending a reminder to sign up, reminding you where and when to be via a direct message at the appropriate time, and clearing the group data each week to allow people to sign up for new groups.

A reach goal is an email address that you could email to notify other members of your check-in group if you're running late, which would then forward the email or direct message the other members of your group, and no one else.

I originally began this project using NodeJS and React, but decided that I wanted to learn Rails, so I re-started it.


###[V1.0 is live!] (http://checkins.recurse.com) 
(requires RC account)

To add a group, the API endpoint is /groups/new

#### V2.0 goals:
 -  add group from main page
 -  list of rooms to choose from
 -  admin permissions
 -  API endpoints for admins (remove groups, recursers, etc, add/change times, rooms in database)


#### future goals:
  - more connections to RC's API (current batches, etc)
  - email checkins@recurse.com to message members of your group
 







