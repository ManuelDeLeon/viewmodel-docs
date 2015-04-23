@echo off

if exist c:\Meteor\viewmodel-explorer\package.js.tmp del c:\Meteor\viewmodel-explorer\package.js.tmp
ren c:\Meteor\viewmodel-explorer\package.js package.js.tmp
copy NUL c:\Meteor\viewmodel-explorer\package.js
type c:\Meteor\viewmodel-explorer\package.js.tmp|replace.bat "debugOnly: false" "debugOnly: true" c:\Meteor\viewmodel-explorer\package.js.tmp>c:\Meteor\viewmodel-explorer\package.js
del c:\Meteor\viewmodel-explorer\package.js.tmp