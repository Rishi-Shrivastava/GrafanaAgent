# GrafanaAgent
TestPort.ps1

This script is like a little helper that goes through a list of computers (servers) and checks if a particular "door" (called a port) is open or closed. Think of a port as a doorway that allows certain kinds of communication into or out of a computer.

Here’s what it does step by step:

📄 Takes a list of servers from a text file (each server name is written on a separate line).

🚪 Chooses a port number to check (in this case, port 5985, which is used for Windows Remote Management).

🔍 Goes through each server one by one and tries to see if that port is open.

If the port is open → it writes "Open".

If the port is closed → it writes "Closed".

If something goes wrong (like the server can’t be reached) → it writes "Error".

📊 Saves all the results into a CSV file (like a spreadsheet) so you can easily read or share them.

✅ Finally, it shows a message saying the check is complete and tells you where the results are saved.
