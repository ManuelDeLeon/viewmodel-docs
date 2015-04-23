@echo off

if exist c:\Meteor\viewmodel-explorer\package.js.tmp del c:\Meteor\viewmodel-explorer\package.js.tmp
ren c:\Meteor\viewmodel-explorer\package.js package.js.tmp
copy NUL c:\Meteor\viewmodel-explorer\package.js
replace.bat "debugOnly: true" "debugOnly: false" c:\Meteor\viewmodel-explorer\package.js.tmp > c:\Meteor\viewmodel-explorer\package.js
del c:\Meteor\viewmodel-explorer\package.js.tmp

meteor deploy viewmodel.meteor.com

if exist c:\Meteor\viewmodel-explorer\package.js.tmp del c:\Meteor\viewmodel-explorer\package.js.tmp
ren c:\Meteor\viewmodel-explorer\package.js package.js.tmp
copy NUL c:\Meteor\viewmodel-explorer\package.js
replace.bat "debugOnly: false" "debugOnly: true" c:\Meteor\viewmodel-explorer\package.js.tmp > c:\Meteor\viewmodel-explorer\package.js
del c:\Meteor\viewmodel-explorer\package.js.tmp