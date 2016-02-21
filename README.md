# Fir filter low pass Deployment

## Description
The project requires to design a digital circuit that implements a FIR (low pass) filter (finite impulse response) of order N (N=6) with a normalized cutoff frequency fT = 0.2 fC (fC = sampling frequency). The mathematical law that rules the filter is shown below:

y[n]= sum(c(i)*x[n-i]) with i going from 0 to N.

where:
1) x[n] represents the input at instant n;
2) ci representes the corresponding factor;
3) y[n] represents the output at instant n;

Inputs, output and factors should be represented by 16 bits. The factors values are: c0 = 0.0135, c1 = 0.0785, c2 = 0.2409, c3 = 0.3344, c4 = 0.2409, c5 = 0.0785, c6 = 0.0135.
