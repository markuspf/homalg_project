#############################################################################
##
##  Service.gi                  homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementations of homalg service procedures.
##
#############################################################################

####################################
#
# methods for operations:
#
####################################

##
InstallMethod( TriangularBasisOfRows,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    local R, RP;
    
    R := HomalgRing( M );
    
    RP := HomalgTable( R );
  
    if IsBound(RP!.TriangularBasisOfRows) then
        return RP!.TriangularBasisOfRows( M );
    fi;
    
    TryNextMethod( );
    
end ); 

##
InstallMethod( TriangularBasisOfRows,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and IsVoidMatrix ],
        
  function( M, U )
    local R, RP;
    
    R := HomalgRing( M );
    
    RP := HomalgTable( R );
    
    if IsBound(RP!.TriangularBasisOfRows) then
        return RP!.TriangularBasisOfRows( M, U );
    fi;
    
    TryNextMethod( );
    
end ); 

##
InstallMethod( TriangularBasisOfColumns,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    local R, RP;
    
    R := HomalgRing( M );
    
    RP := HomalgTable( R );
    
    if IsBound(RP!.TriangularBasisOfColumns) then
        return RP!.TriangularBasisOfColumns( M );
    fi;
    
    return Involution( TriangularBasisOfRows( Involution( M ) ) );
    
end ); 

##
InstallMethod( TriangularBasisOfColumns,
        "for homalg matrices",
	[ IsHomalgMatrix, IsHomalgMatrix and IsVoidMatrix ],
        
  function( M, V )
    local R, RP, T, U;
    
    R := HomalgRing( M );
    
    RP := HomalgTable( R );
    
    if IsBound(RP!.TriangularBasisOfColumns) then
        return RP!.TriangularBasisOfColumns( M, V );
    fi;
    
    U := HomalgMatrix( "void", R );
    
    T := Involution( TriangularBasisOfRows( Involution( M ), U ) );
    
    SetEvalInvolution( V, U ); ResetFilterObj( V, IsVoidMatrix );
    SetNrRows( V, NrColumns( U ) );
    SetNrColumns( V, NrRows( U ) );
    SetIsInvertibleMatrix( V, true );
    
    return T;
    
end ); 

##
InstallMethod( TriangularBasisOfRows,
        "for homalg matrices",
	[ IsHomalgMatrix and IsZeroMatrix ],
        
  function( M )
    
    return  M;
    
end );

##
InstallMethod( TriangularBasisOfColumns,
        "for homalg matrices",
	[ IsHomalgMatrix and IsZeroMatrix ],
        
  function( M )
    
    return M;
    
end );
    
##
InstallMethod( TriangularBasisOfRows,
        "for homalg matrices",
	[ IsHomalgMatrix and IsIdentityMatrix ],
        
  function( M )
    
    return M;
    
end );
    
##
InstallMethod( TriangularBasisOfColumns,
        "for homalg matrices",
	[ IsHomalgMatrix and IsIdentityMatrix ],
        
  function( M )
    
    return  M;
    
end );

##
InstallMethod( BasisOfRowModule,		### defines: BasisOfRowModule (BasisOfModule (low-level))
        "for homalg matrices",
	[ IsHomalgMatrix ],
        
  function( M )
    local R, RP, U, B, rank, Ur, Uc;
    
    R := HomalgRing( M );
    
    RP := HomalgTable( R );
  
    if IsBound(RP!.BasisOfRowModule) then
        return RP!.BasisOfRowModule( M );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    if HasRightHandSide( M ) then
        U := HomalgMatrix( "void", R );
        
        B := TriangularBasisOfRows( M, U );
    else
        B := TriangularBasisOfRows( M );
    fi;
    
    rank := RowRankOfMatrix( B );
    
    if rank = 0 then
        B := HomalgMatrix( "zero", 0, NrColumns( B ), R);
    else
        B := CertainRows( B, [ 1 .. rank ] );
        
        SetRowRankOfMatrix( B, rank );
	
        SetIsFullRowRankMatrix( B, true );
    fi;
    
    if HasRightHandSide( M ) then
        Ur := CertainRows( U, [ 1 .. rank ] );
        Uc := CertainRows( U, [ rank + 1 .. NrRows( M ) ] );
        
        SetRightHandSide( B, Ur * RightHandSide( M ) );
        
        SetCompatibilityConditions( B, Uc * RightHandSide( M ) );
    fi;
    
    return B;
    
end );

##
InstallMethod( BasisOfColumnModule,		### defines: BasisOfColumnModule (BasisOfModule (low-level))
        "for homalg matrices",
	[ IsHomalgMatrix ],
        
  function( M )
    local R, RP, U, B, rank, Ur, Uc;
    
    R := HomalgRing( M );
    
    RP := HomalgTable( R );
  
    if IsBound(RP!.BasisOfColumnModule) then
        return RP!.BasisOfColumnModule( M );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    if HasBottomSide( M ) then
        U := HomalgMatrix( "void", R );
        
        B := TriangularBasisOfColumns( M, U );
    else
        B := TriangularBasisOfColumns( M );
    fi;
    
    rank := ColumnRankOfMatrix( B );
    
    if rank = 0 then
        B := HomalgMatrix( "zero", NrRows( B ), 0, R);
    else
        B := CertainColumns( B, [1..rank] );
        
        SetColumnRankOfMatrix( B, rank );
	
        SetIsFullColumnRankMatrix( B, true );
    fi;
    
    if HasBottomSide( M ) then
        Ur := CertainColumns( U, [ 1 .. rank ] );
        Uc := CertainColumns( U, [ rank + 1 .. NrColumns( M ) ] );
        
        SetBottomSide( B, BottomSide( M ) * Ur );
        
        SetCompatibilityConditions( B, BottomSide( M ) * Uc );
    fi;
    
    return B;
    
end );

##
InstallMethod( BasisOfRowsCoeff,		### defines: BasisOfRowsCoeff (BasisCoeff)
        "for a homalg matrix",
	[ IsHomalgMatrix, IsHomalgMatrix and IsVoidMatrix ],
        
  function( M, U )
    local R, RP, bas;
    
    R := HomalgRing( M );
    
    RP := HomalgTable( R );
    
    if IsBound(RP!.BasisOfRowsCoeff) then
        return RP!.BasisOfRowsCoeff( M, U );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    bas := BasisOfRows( AddRhs( M ) );
    
    SetPreEval( U, RightHandSide( bas ) ); ResetFilterObj( U, IsVoidMatrix );
    SetNrRows( U, NrRows( bas ) );
    SetNrColumns( U, NrRows( M ) );
    
    return bas;
    
end );

##
InstallMethod( BasisOfColumnsCoeff,		### defines: BasisOfRowsCoeff (BasisCoeff)
        "for a homalg matrix",
	[ IsHomalgMatrix, IsHomalgMatrix and IsVoidMatrix ],
        
  function( M, V )
    local R, RP, U, ibas;
    
    R := HomalgRing( M );
    
    RP := HomalgTable( R );
    
    if IsBound(RP!.BasisOfColumnsCoeff) then
        return RP!.BasisOfColumnsCoeff( M, V );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    U := HomalgMatrix( "void", R );
    
    ibas := BasisOfRowsCoeff( Involution( M ), U );
    
    SetEvalInvolution( V, U ); ResetFilterObj( V, IsVoidMatrix );
    
    return Involution( ibas );
    
end );

##
InstallMethod( DecideZeroRows,			### defines: DecideZeroRows (Reduce)
        "for homalg matrices",
	[ IsHomalgMatrix, IsHomalgMatrix ],
        
  function( L, B )
    local R, RP, l, m, n, id, zz, M, U, C, Ul, T;
    
    R := HomalgRing( B );
    
    RP := HomalgTable( R );
    
    if IsBound(RP!.DecideZeroRows) then
        return RP!.DecideZeroRows( L, B );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    l := NrRows( L );
    m := NrColumns( L );
    
    n := NrRows( B );
    
    id := HomalgMatrix( "identity", l, R );
    
    zz := HomalgMatrix( "zero", n, l, R );
    
    M := UnionOfRows( UnionOfColumns( id, L ), UnionOfColumns( zz, B ) );
    
    if HasRightHandSide( B ) then
        U := HomalgMatrix( "void", R );
        
        M := TriangularBasisOfRows( M, U );
    else
        M := TriangularBasisOfRows( M );
    fi;
    
    C := CertainRows( CertainColumns( M, [ l + 1 .. l + m ] ), [ 1 .. l ] );
    
    if HasRightHandSide( B ) then
        
        Ul := CertainRows( U, [ 1 .. l ] );
        
        if HasRightHandSide( L ) then
            T := Ul * UnionOfRows( RightHandSide( L ), RightHandSide( B ) );
        else
            T := CertainColumns( Ul, [ l + 1 .. l + n ] ) * RightHandSide( B );
        fi;
        
        SetRightHandSide( C, T );
    fi;
    
    return C;
    
end );

##
InstallMethod( DecideZeroRows,
        "for homalg matrices",
	[ IsHomalgMatrix, IsHomalgMatrix and IsZeroMatrix ],
        
  function( L, B )
    
    return L;
    
end );

##
InstallMethod( DecideZeroRows,
        "for homalg matrices",
	[ IsHomalgMatrix and IsZeroMatrix, IsHomalgMatrix ],
        
  function( L, B )
    
    return L;
    
end );

##
InstallMethod( DecideZeroColumns,		### defines: DecideZeroColumns (Reduce)
        "for homalg matrices",
	[ IsHomalgMatrix, IsHomalgMatrix ],
        
  function( L, B )
    local R, RP, l, m, n, id, zz, M, U, C, Ul, T;
    
    R := HomalgRing( B );
    
    RP := HomalgTable( R );
    
    if IsBound(RP!.DecideZeroColumns) then
        return RP!.DecideZeroColumns( L, B );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    l := NrColumns( L );
    m := NrRows( L );
    
    n := NrColumns( B );
    
    id := HomalgMatrix( "identity", l, R );
    
    zz := HomalgMatrix( "zero", l, n, R );
    
    M := UnionOfColumns( UnionOfRows( id, L ), UnionOfRows( zz, B ) );
    
    if HasBottomSide( B ) then
        U := HomalgMatrix( "void", R );
        
        M := TriangularBasisOfColumns( M, U );
    else
        M := TriangularBasisOfColumns( M );
    fi;
    
    C := CertainColumns( CertainRows( M, [ l + 1 .. l + m ] ), [ 1 .. l ] );
    
    if HasBottomSide( B ) then
        
        Ul := CertainColumns( U, [ 1 .. l ] );
        
        if HasBottomSide( L ) then
            T := UnionOfColumns( BottomSide( L ), BottomSide( B ) ) * Ul;
        else
            T := BottomSide( B ) * CertainRows( Ul, [ l + 1 .. l + n ] );
        fi;
        
        SetBottomSide( C, T );
    fi;
    
    return C;
    
end );

##
InstallMethod( DecideZeroColumns,
        "for homalg matrices",
	[ IsHomalgMatrix, IsHomalgMatrix and IsZeroMatrix ],
        
  function( L, B )
    
    return L;
    
end );

##
InstallMethod( DecideZeroColumns,
        "for homalg matrices",
	[ IsHomalgMatrix and IsZeroMatrix, IsHomalgMatrix ],
        
  function( L, B )
    
    return L;
    
end );

##
InstallMethod( EffectivelyDecideZeroRows,	### defines: EffectivelyDecideZeroRows (ReduceCoeff)
        "for a homalg matrix",
	[ IsHomalgMatrix, IsHomalgMatrix, IsHomalgMatrix and IsVoidMatrix ],
        
  function( A, B, U )
    local R, RP, zz, A_zz, red;
    
    R := HomalgRing( B );
    
    RP := HomalgTable( R );
  
    if IsBound(RP!.EffectivelyDecideZeroRows) then
        return RP!.EffectivelyDecideZeroRows( A, B, U );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    zz := HomalgMatrix( "zero", NrRows( A ), NrRows( B ), R );
    
    A_zz := AddRhs( A, zz );
    
    red := DecideZeroRows( A_zz, AddRhs( B ) );
    
    SetPreEval( U, RightHandSide( red ) ); ResetFilterObj( U, IsVoidMatrix );
    SetNrRows( U, NrRows( red ) );
    SetNrColumns( U, NrRows( A ) );
    
    return red;
    
end );

##
InstallMethod( EffectivelyDecideZeroColumns,	### defines: EffectivelyDecideZeroColumns (ReduceCoeff)
        "for a homalg matrix",
	[ IsHomalgMatrix, IsHomalgMatrix, IsHomalgMatrix and IsVoidMatrix ],
        
  function( A, B, V )
    local R, RP, U, ired;
    
    R := HomalgRing( B );
    
    RP := HomalgTable( R );
  
    if IsBound(RP!.EffectivelyDecideZeroColumns) then
        return RP!.EffectivelyDecideZeroColumns( A, B, V );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    U := HomalgMatrix( "void", R );
    
    ired := EffectivelyDecideZeroRows( Involution( A ), Involution( B ), U );
    
    SetEvalInvolution( V, U ); ResetFilterObj( V, IsVoidMatrix );
    
    return Involution( ired );
    
end );

##
InstallMethod( SyzygiesGeneratorsOfRows,
        "for homalg matrices",
	[ IsHomalgMatrix ],
        
  function( M )
    local R, RP, L, BL;
    
    R := HomalgRing( M );
    
    RP := HomalgTable( R );
  
    if IsBound(RP!.SyzygiesGeneratorsOfRows) then
        return RP!.SyzygiesGeneratorsOfRows( M );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    L := AddRhs( M );
    
    BL := BasisOfRows( L );
    
    return CompatibilityConditions( BL );
    
end );

##
InstallMethod( SyzygiesGeneratorsOfRows,	### defines: SyzygiesGeneratorsOfRows (SyzygiesGenerators)
        "for homalg matrices",
	[ IsHomalgMatrix, IsHomalgMatrix ],
        
  function( M1, M2 )
    local R, RP, id, zz, L, BL;
    
    R := HomalgRing( M1 );
    
    RP := HomalgTable( R );
  
    if IsBound(RP!.SyzygiesGeneratorsOfRows) then
        return RP!.SyzygiesGeneratorsOfRows( M1, M2 );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    id := HomalgMatrix( "identity", NrRows( M1 ), R );
    
    zz := HomalgMatrix( "zero", NrRows( M2 ), NrRows( M1 ), R );
    
    L := UnionOfRows( M1, M2 );
    
    SetRightHandSide( L, UnionOfRows( id, zz ) );
    
    BL := BasisOfRows( L );
    
    return CompatibilityConditions( BL );
    
end );

##
InstallMethod( SyzygiesGeneratorsOfColumns,
        "for homalg matrices",
	[ IsHomalgMatrix ],
        
  function( M )
    local R, RP;
    
    R := HomalgRing( M );
    
    RP := HomalgTable( R );
  
    if IsBound(RP!.SyzygiesGeneratorsOfColumns) then
        return RP!.SyzygiesGeneratorsOfColumns( M );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    return SyzygiesGeneratorsOfRows( Involution( M ) );
    
end );

##
InstallMethod( SyzygiesGeneratorsOfColumns,	### defines: SyzygiesGeneratorsOfColumns (SyzygiesGenerators)
        "for homalg matrices",
	[ IsHomalgMatrix, IsHomalgMatrix ],
        
  function( M1, M2 )
    local R, RP;
    
    R := HomalgRing( M1 );
    
    RP := HomalgTable( R );
  
    if IsBound(RP!.SyzygiesGeneratorsOfColumns) then
        return RP!.SyzygiesGeneratorsOfColumns( M1, M2 );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    return SyzygiesGeneratorsOfRows( Involution( M1 ), Involution( M2 ) );
    
end );

