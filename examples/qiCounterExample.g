LoadPackage( "homalg" );
R := HomalgRingOfIntegers( );
M := 1 * R;
N := LeftPresentation( [ 3 ], R );
a := HomalgMap( [ 2 ], M, M );
c := HomalgMap( [ 2 ], M, N );
b := HomalgMap( [ 1 ], M, M );
d := HomalgMap( [ 1 ], M, N );
C1 := HomalgComplex( a );
C2 := HomalgComplex( c );
cm := HomalgChainMap( d, C1, C2 );
Add( cm, b );
hcm := DefectOfExactness( cm );
ByASmallerPresentation( hcm );
