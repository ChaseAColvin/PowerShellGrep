# PowerGrep
A single-function, single-file powershell module that acts as an interface for the Select-String cmdlet. It passes input objects through Out-String with the -Stream parameter, then passes the output into the Select-String. The grep function parameters (only -e, -i, -v, and -c currently) are used to set parameters in a hash table, which are then splat onto Select-String.

NOTES:

This was done on a whim, and just for fun. I am well aware (clearly) that everything that grep does can be done natively in powershell. Though I do feel there is something to be said about the simplicity of working with grep.

I have not yet added the help data. Though those who already prefer working with grep should not need it, I still intend to add it at some point.
