# PowerGrep
A single-function, single-file powershell module that acts as an interface for the Select-String cmdlet. It passes input objects through Out-String with the -Stream parameter, then passes the output into the Select-String. the grep function parameters (only -e, -i, -v, and -c currently) are used to set parameters in a hash table, which are then splat onto Select-String.
