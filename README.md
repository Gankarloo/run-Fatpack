# run-fatpacker 
## Description
A simple scripts that handles setting up:  
  * Environment.  
  * Downloads cpm if missing.  
  * Installs all dependencies to a project local folder  
  * Checks for perl compile errors  
  * Removes non .pm files from local lib
  * Runs perlstrip on all files.  

## Usage
Create your cpanfile with all required modules.  
A good start is:
```perl
requires 'App::FatPacker';
requires 'Perl::Strip';
```

Now run it like this.
```bash
./run-fatpacker myapp.pl
```
If you have a git repo for your project the script will add cpm as a submodule.  

If all goes well you will end up with a new file called myapp.packed.pl which includes all your dependencies.

This was inspired by Andrew Rodland presentation ["Fatpack it! Full featured Perl apps in a single file"](https://youtu.be/Pe9pEbUsYSY)
### See also
* [fatpack](https://metacpan.org/pod/distribution/App-FatPacker/bin/fatpack)
* [Perl::Strip](https://metacpan.org/pod/Perl::Strip)
* [cpm](https://github.com/skaji/cpm)


