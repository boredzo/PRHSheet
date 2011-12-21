# PRHSheet
## A reusable subclass of NSPanel to make deploying sheets much saner

### Features/Improvements over built-in API

- Responds to `ok:` and `cancel:`, so you can connect OK/Done and Cancel buttons directly to the sheet and have them work
- No need to talk to `NSApp` for something that's none of its business
- No more callback object and selector; instead, you pass a block
- Automatically orders itself out when you end or the user ends the sheet
