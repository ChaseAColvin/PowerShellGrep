# PowerGrep
A single-function, single-file powershell module that acts as an interface for the Select-String cmdlet. It passes input objects through Out-String with the -Stream parameter, then passes the output into the Select-String. the grep function parameters (only -e, -i, -v, and -c currently) are used to set parameters in a hash table, which are then splat onto Select-String.

This was done just for fun. I am well aware (clearly) that everything that grep does can be done natively in powershell. Though I feel there is something to be said about the simplicity of working with grep.

NOTE: I did this on a whim and have not yet added the help data yet. Though those who prefer working with grep already should not need it, I intend to do this at some point.
