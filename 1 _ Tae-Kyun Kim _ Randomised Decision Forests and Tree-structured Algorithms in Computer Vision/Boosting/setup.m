% Compile C++ wraps

cfiles = dir('c_wrap/*.c');
 for n = 1:5
     mex(['c_wrap/' cfiles(n).name]);
 end