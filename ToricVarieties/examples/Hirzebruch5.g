LoadPackage( "ToricVarieties" );
H5 := Fan( [[-1,5],[0,1],[1,0],[0,-1]],[[1,2],[2,3],[3,4],[4,1]] );
H5 := ToricVariety( H5 );
IsComplete( H5 );
IsAffine( H5 );
IsOrbifold( H5 );
H5;
ClassGroup( H5 );
PicardGroup( H5 );
ByASmallerPresentation( last );
CoxRing( H5 );
CoordinateRingOfTorus( H5, "y" );
H5;
P := TorusInvariantPrimeDivisors( H5 );
D1 := P[1]+2*P[2]+3*P[3];
IsCartier( D1 );
CartierData( D1 );
Polytope( D1 );
BasisOfGlobalSections( D1 );
IsAmple( D1 );
IsBasepointFree( D1 );
D2 := DivisorOfCharacter( [ 1, 2 ], H5 );
IsAmple( D2 );
CoxRingOfTargetOfDivisorMorphism( D2 );
RingMorphismOfDivisor( D2 );
Display(last);
MonomsOfCoxRingOfDegree( D2 );
D3 := Divisor( [ 0, 0, 1, 1 ], H5 );
IsAmple( D3 );
H5;
RingMorphismOfDivisor( D3 );
Display(last);