ContinousDepreciation(r,t)$(OperationalLife(r,t) <> 0) = 1 - exp( 1 / ( - OperationalLife(r,t) + (0.01/2) * OperationalLife(r,t)**2) ); 
ContinousDepreciation(r,t)$(OperationalLife(r,t) = 0) = 1; 