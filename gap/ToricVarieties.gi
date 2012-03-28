#############################################################################
##
##  ToricVariety.gi         ToricVarieties package         Sebastian Gutsche
##
##  Copyright 2011 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  The Category of toric Varieties
##
#############################################################################

#################################
##
## Global Variables
##
#################################

InstallValue( TORIC_VARIETIES,
        rec(
            category := rec(
                            description := "toric varieties",
                            short_description := "toric varieties",
                            MorphismConstructor := ToricMorphism,
                            ),
            CoxRingIndet := "x",
           )
);

#################################
##
## Representations
##
#################################

DeclareRepresentation( "IsToricVarietyRep",
                       IsToricVariety and IsAttributeStoringRep,
                       [ ]
                      );

DeclareRepresentation( "IsSheafRep",
                       IsToricVarietyRep and IsAttributeStoringRep,
                       [ "Sheaf" ]
                      );

DeclareRepresentation( "IsCombinatoricalRep",
                       IsToricVarietyRep and IsAttributeStoringRep,
                       [ ]
                      );

DeclareRepresentation( "IsFanRep",
                       IsCombinatoricalRep,
                       [ ]
                      );

##################################
##
## Family and Type
##
##################################

BindGlobal( "TheFamilyOfToricVarietes",
        NewFamily( "TheFamilyOfToricVarietes" , IsToricVariety ) );

BindGlobal( "TheTypeFanToricVariety",
        NewType( TheFamilyOfToricVarietes,
                 IsFanRep ) );

##################################
##
## Properties
##
##################################

##
InstallMethod( IsNormalVariety,
               " for convex varieties",
               [ IsFanRep ],
               
  function( variety )
    
    return true;
    
end );

##
InstallMethod( IsAffine,
               " for convex varieties",
               [ IsFanRep ],
               
  function( variety )
    local fan_of_variety, weil_divisor;
    
    fan_of_variety := FanOfVariety( variety );
    
    if Length( MaximalCones( fan_of_variety ) ) = 1 then
        
        for weil_divisor in WeilDivisorsOfVariety( variety ) do
            
            if HasIsCartier( weil_divisor ) then
                
                SetIsPrincipal( weil_divisor, IsCartier( weil_divisor ) );
                
            fi;
            
        od;
        
        return true;
        
    fi;
    
    return false;
    
end );

##
InstallMethod( IsProjective,
               "for convex varieties",
               [ IsFanRep and IsComplete ],
               
  function( variety )
    
    if Dimension( variety ) <= 2 then
        
        return true;
        
    fi;
    
    TryNextMethod();
    
end );

##
InstallMethod( IsProjective,
               "for convex varieties",
               [ IsToricVariety ],
               
  function( variety )
    
    if not IsComplete( variety ) then
        
        return false;
        
    fi;
    
    TryNextMethod();
    
end );

##
RedispatchOnCondition( IsProjective, true, [ IsToricVariety ], [ IsComplete ], 0 );

##
InstallMethod( IsSmooth,
               " for convex varieties",
               [ IsFanRep ],
               
  function( variety )
    
    return IsSmooth( FanOfVariety( variety ) );
    
end );

##
InstallMethod( IsComplete,
               " for convex varieties",
               [ IsFanRep ],
               
  function( variety )
    
    return IsComplete( FanOfVariety( variety ) );
    
end );

##
InstallMethod( HasTorusfactor,
               " for convex varieties",
               [ IsFanRep ],
               
  function( variety )
    
    return not IsFullDimensional( FanOfVariety( variety ) );
    
end );

##
InstallMethod( HasNoTorusfactor,
               " for convex varieties",
               [ IsFanRep ],
               
  function( variety )
    
    return not HasTorusfactor( variety );
    
end );

##
InstallMethod( IsOrbifold,
               " for convex varieties",
               [ IsFanRep ],
               
  function( variety )
    
    return IsSimplicial( FanOfVariety( variety ) );
    
end );

##################################
##
## Attributes
##
##################################

##
InstallMethod( Dimension,
               " for convex varieties",
               [ IsFanRep ],
               
  function( variety )
    
    return AmbientSpaceDimension( FanOfVariety( variety ) );
    
end );

##
InstallMethod( DimensionOfTorusfactor,
               "for convex varieties",
               [ IsFanRep ],
               
  function( variety )
    local dimension_of_fan, ambient_dimension;
    
    if not HasTorusfactor( variety ) then
        
        return 0;
    fi;
    
    dimension_of_fan := Dimension( FanOfVariety( variety ) );
    
    ambient_dimension := Dimension( variety );
    
    return ambient_dimension - dimension_of_fan;
    
end );

##
InstallMethod( AffineOpenCovering,
               " for convex varieties",
               [ IsFanRep ],
               
  function( variety )
    local cones, cover_varieties;
    
    cones := MaximalCones( FanOfVariety( variety ) );
    
    cover_varieties := List( cones, ToricVariety );
    
    cover_varieties := List( cover_varieties, i -> ToricSubvariety( i, variety ) );
    
    return cover_varieties;
    
end );

##
InstallMethod( IsProductOf,
               " for convex varieties",
               [ IsToricVariety ],
               
  function( variety )
    
    return [ variety ];
    
end );

##
InstallMethod( TorusInvariantDivisorGroup,
               "for toric varieties",
               [ IsFanRep ],
               
  function( variety )
    local rays;
    
    if Length( IsProductOf( variety ) ) > 1 then
        
        return DirectSum( List( IsProductOf( variety ), TorusInvariantDivisorGroup ) );
        
    fi;
    
    rays := Length( RayGenerators( FanOfVariety( variety ) ) );
    
    return rays * HOMALG_MATRICES.ZZ;
    
end );

##
InstallMethod( MapFromCharacterToPrincipalDivisor,
               " for convex varieties",
               [ IsFanRep ],
               
  function( variety )
    local dim_of_variety, rays, ray_matrix;
    
    if Length( IsProductOf( variety ) ) > 1 then
        
        return DiagonalMorphism( List( IsProductOf( variety ), MapFromCharacterToPrincipalDivisor ) );
        
    fi;
    
    dim_of_variety := Dimension( variety );
    
    rays := RayGenerators( FanOfVariety( variety ) );
    
    ray_matrix := HomalgMatrix( Flat( rays ), Length( rays ), dim_of_variety, HOMALG_MATRICES.ZZ );
    
    ray_matrix := Involution( ray_matrix );
    
    return HomalgMap( ray_matrix, CharacterLattice( variety ), TorusInvariantDivisorGroup( variety ) );
    
end );

# ##
# InstallMethod( ClassGroup,
#                " for convex varieties",
#                [ IsFanRep ],
#                
#   function( variety )
#     
#     if Length( IsProductOf( variety ) ) > 1 then
#         
#         return Sum( List( IsProductOf( variety ), ClassGroup ) );
#         
#     fi;
#     
#     return Cokernel( MapFromCharacterToPrincipalDivisor( variety ) );
#     
# end );

##
InstallMethod( CharacterLattice,
               "for convex toric varieties.",
               [ IsCombinatoricalRep ],
               
  function( variety )
    
    return ContainingGrid( FanOfVariety( variety ) );
    
end );

##
InstallMethod( CoxRing,
               "for convex varieties.",
               [ IsToricVariety ],
               
  function( variety )
    
    return CoxRing( variety, TORIC_VARIETIES.CoxRingIndet );
    
end );

##
InstallMethod( CoxRing,
               "for convex toric varieties.",
               [ IsToricVariety, IsString ],
               
  function( variety, variable )
    
    Error( "Cox ring not defined for varieties with torus factor\n" );
    
end );

##
RedispatchOnCondition( CoxRing, true, [ IsToricVariety ], [ HasNoTorusfactor ], 1 );

##
InstallMethod( CoxRing,
               "for convex toric varieties.",
               [ IsToricVariety and HasNoTorusfactor, IsString ],
               
  function( variety, variable )
    local raylist, indeterminates, ring, class_list;
    
    raylist := RayGenerators( FanOfVariety( variety ) );
    
    indeterminates := List( [ 1 .. Length( raylist ) ], i -> JoinStringsWithSeparator( [ variable, i ], "_" ) );
    
    indeterminates := JoinStringsWithSeparator( indeterminates, "," );
    
    ring := GradedRing( DefaultFieldForToricVarieties() * indeterminates );
    
    SetDegreeGroup( ring, ClassGroup( variety ) );
    
    indeterminates := Indeterminates( ring );
    
    class_list := List( TorusInvariantPrimeDivisors( variety ), i -> ClassOfDivisor( i ) );
    
    SetWeightsOfIndeterminates( ring, class_list );
    
    SetCoxRing( variety, ring );
    
    return ring;
    
end );

##
InstallMethod( ListOfVariablesOfCoxRing,
               "for toric varieties with cox rings",
               [ IsToricVariety ],
               
  function( variety )
    local cox_ring, variable_list, string_list, i;
    
    if not HasCoxRing( variety ) then
        
        Error( "no cox ring has no variables\n" );
        
    fi;
    
    cox_ring := CoxRing( variety );
    
    variable_list := Indeterminates( cox_ring );
    
    string_list := [ ];
    
    for i in variable_list do
        
        Add( string_list, String( i ) );
        
    od;
    
    return string_list;
    
end );

##
InstallMethod( IrrelevantIdeal,
               "for toric varieties",
               [ IsToricVariety and IsAffine ],
               
  function( variety )
    local cox_ring, irrelevant_ideal;
    
    cox_ring := CoxRing( variety );
    
    irrelevant_ideal := HomalgMatrix( [ 1 ], 1, 1, cox_ring );
    
    return LeftSubmodule( irrelevant_ideal );
    
end );

##
InstallMethod( IrrelevantIdeal,
               " for toric varieties",
               [ IsFanRep ],
               
  function( variety )
    local cox_ring, maximal_cones, indeterminates, irrelevant_ideal, i, j;
    
    cox_ring := CoxRing( variety );
    
    maximal_cones := RaysInMaximalCones( FanOfVariety( variety ) );
    
    indeterminates := Indeterminates( cox_ring );
    
    irrelevant_ideal := [ 1 .. Length( maximal_cones ) ];
    
    
    for i in [ 1 .. Length( maximal_cones ) ] do
        
        irrelevant_ideal[ i ] := 1;
        
        for j in [ 1 .. Length( maximal_cones[ i ] ) ] do
            
            irrelevant_ideal[ i ] := irrelevant_ideal[ i ] * indeterminates[ j ]^( 1 - maximal_cones[ i ][ j ] );
            
        od;
        
    od;
    
    irrelevant_ideal := HomalgMatrix( irrelevant_ideal, Length( irrelevant_ideal ), 1, cox_ring );
    
    return LeftSubmodule( irrelevant_ideal );
    
end );

##
InstallMethod( MorphismFromCoxVariety,
               "for toric varieties",
               [ IsFanRep ],
               
  function( variety )
    local fan, rays, rays_for_cox_variety, cones_for_cox_variety, fan_for_cox_variety, cox_variety, i, j;
    
    fan := FanOfVariety( variety );
    
    rays := RayGenerators( fan );
    
    rays_for_cox_variety := IdentityMat( Length( rays ) );
    
    cones_for_cox_variety := RaysInMaximalCones( fan );
    
    fan_for_cox_variety := List( cones_for_cox_variety, i -> [ ] );
    
    for i in [ 1 .. Length( cones_for_cox_variety ) ] do
        
        for j in [ 1 .. Length( rays ) ] do
            
            if cones_for_cox_variety[ i ][ j ] = 1 then
                
                Add( fan_for_cox_variety[ i ], rays_for_cox_variety[ j ] );
                
            fi;
            
        od;
        
    od;
    
    fan_for_cox_variety := Fan( fan_for_cox_variety );
    
    cox_variety := ToricVariety( fan_for_cox_variety );
    
    return ToricMorphism( cox_variety, rays, variety );
    
end );

##
InstallMethod( CartierTorusInvariantDivisorGroup,
               " for conv toric varieties",
               [ IsCombinatoricalRep and HasNoTorusfactor ],
               
  function( variety )
    local rays, maximal_cones, number_of_rays, number_of_cones, rank_of_charactergrid, maximal_cone_grid,
          rank_of_maximal_cone_grid, map_for_difference_of_elements, map_for_scalar_products, total_map,
          current_row, i, j, k, cartier_data_group, morphism_to_cartier_data_group,
          zero_ray, map_from_cartier_data_group_to_divisors;
    
    if HasTorusfactor( variety ) then
        
        Error( "warning, computation may be wrong\n" );
        
    fi;
    
    rays := RayGenerators( FanOfVariety( variety ) );
    
    maximal_cones := RaysInMaximalCones( FanOfVariety( variety ) );
    
    number_of_rays := Length( rays );
    
    number_of_cones := Length( maximal_cones );
    
    rank_of_charactergrid := Rank( CharacterLattice( variety ) );
    
    maximal_cone_grid := number_of_cones * CharacterLattice( variety );
    
    rank_of_maximal_cone_grid := number_of_cones * rank_of_charactergrid;
    
    map_for_difference_of_elements := [ ];
    
    map_for_scalar_products := [ ];
    
    for i in [ 2 .. number_of_cones ] do
        
        for j in [ 1 .. i-1 ] do
            
            current_row := List( [ 1 .. rank_of_maximal_cone_grid ], function( k )
                                                      if i*rank_of_charactergrid >= k and k > (i-1)*rank_of_charactergrid then
                                                          return 1;
                                                      elif j*rank_of_charactergrid >= k and k > (j-1)*rank_of_charactergrid then
                                                          return -1;
                                                      fi;
                                                      return 0;
                                                    end );
            
            Add( map_for_difference_of_elements, current_row );
            
            current_row := maximal_cones[ i ] + maximal_cones[ j ];
            
            current_row := List( current_row, function( k ) if k = 2 then return 1; fi; return 0; end );
            
            current_row := List( [ 1 .. number_of_rays ], k -> current_row[ k ] * rays[ k ] );
            
            Add( map_for_scalar_products, Flat( current_row ) );
            
        od;
        
    od;
    
    map_for_difference_of_elements := Involution( HomalgMatrix( map_for_difference_of_elements, HOMALG_MATRICES.ZZ ) );
    
    map_for_scalar_products := HomalgMatrix( map_for_scalar_products, HOMALG_MATRICES.ZZ );
    
    total_map := map_for_difference_of_elements * map_for_scalar_products;
    
    total_map := HomalgMap( total_map, maximal_cone_grid, "free" );
    
    cartier_data_group := KernelSubobject( total_map );
    
    morphism_to_cartier_data_group := MorphismHavingSubobjectAsItsImage( cartier_data_group );
    
    zero_ray := List( [ 1 .. rank_of_charactergrid ], i -> 0 );
    
    map_from_cartier_data_group_to_divisors := [ ];
    
    for i in [ 1 .. number_of_rays ] do
        
        current_row := [ ];
        
        j := 1;
        
        while maximal_cones[ j ][ i ] = 0 and j <= number_of_cones do
            
            Add( current_row, zero_ray );
            
            j := j + 1;
            
        od;
        
        if j > number_of_cones then
            
            Error( "there seems to be a ray which is in no max cone. Something went wrong\n" );
            
        fi;
        
        Add( current_row, rays[ i ] );
        
        j := j + 1;
        
        while j <= number_of_cones do
            
            Add( current_row, zero_ray );
            
            j := j + 1;
            
        od;
        
        current_row := Flat( current_row );
        
        Add( map_from_cartier_data_group_to_divisors, current_row );
        
    od;
    
    map_from_cartier_data_group_to_divisors := HomalgMatrix( map_from_cartier_data_group_to_divisors, HOMALG_MATRICES.ZZ );
    
    map_from_cartier_data_group_to_divisors := Involution( map_from_cartier_data_group_to_divisors );
    
    map_from_cartier_data_group_to_divisors := HomalgMap( map_from_cartier_data_group_to_divisors, Range( morphism_to_cartier_data_group ), TorusInvariantDivisorGroup( variety ) );
    
    return ImageSubobject( map_from_cartier_data_group_to_divisors );
    
end );

##
RedispatchOnCondition( CartierTorusInvariantDivisorGroup, true, [ IsCombinatoricalRep ], [ HasNoTorusfactor ], 0 );

##
InstallMethod( FanOfVariety,
               "for products",
               [ IsToricVariety ],
               
  function( variety )
    local factors, fans_of_factors;
    
    factors := IsProductOf( variety );
    
    if Length( factors ) > 1 then
        
        fans_of_factors := List( factors, FanOfVariety );
        
        return Product( fans_of_factors );
        
    fi;
    
    TryNextMethod();
    
end );

##
InstallMethod( CotangentSheaf,
               "for toric varieties",
               [ IsToricVariety and IsOrbifold and HasNoTorusfactor ],
               
  CotangentSheafViaEulerSequence
  
);

InstallGlobalFunction( CotangentSheafViaPoincareResidueMap,
               
  function( variety )
    local cox_ring, variables, factor_module_morphisms, ray_matrix, dim, source_module, i,
          akt_morphism, product_morphism;
    
    cox_ring := CoxRing( variety );
    
    dim := Dimension( variety );
    
    ray_matrix := RayGenerators( FanOfVariety( variety ) );
    
    variables := Indeterminates( cox_ring );
    
    source_module := dim * cox_ring;
    
    factor_module_morphisms := [ ];
    
    for i in [ 1 .. Length( ray_matrix ) ] do
        
        akt_morphism := Involution( HomalgMatrix( [ ray_matrix[ i ] ], cox_ring ) );
        
        akt_morphism := GradedMap( akt_morphism, source_module, 1 * cox_ring / GradedLeftSubmodule( [ variables[ i ] ], cox_ring ) );
        
        Add( factor_module_morphisms, akt_morphism );
        
    od;
    
    product_morphism := Iterated( factor_module_morphisms, ProductMorphism );
    
    return Kernel( product_morphism );
    
end );

InstallGlobalFunction( CotangentSheafViaEulerSequence,
                       
  function( variety )
    local cox_ring, variables, source_module, prime_divisors, cokernel_epi,
          product_morphism;
    
    cox_ring := CoxRing( variety );
    
    prime_divisors := TorusInvariantPrimeDivisors( variety );
    
    variables := Indeterminates( cox_ring );
    
    source_module := List( [ 1 .. Length( prime_divisors ) ], i -> cox_ring^( -ClassOfDivisor( prime_divisors[ i ] ) ) );
        
    source_module := Sum( source_module );
    
    product_morphism := HomalgDiagonalMatrix( variables, cox_ring );
    
    cokernel_epi := CokernelEpi( MapFromCharacterToPrincipalDivisor( variety ) );
    
    cokernel_epi := GradedMap( UnderlyingNonGradedRing( cox_ring ) * cokernel_epi, cox_ring );
    
    product_morphism := GradedMap( product_morphism, source_module, Source( cokernel_epi ) );
    
    product_morphism := PreCompose( product_morphism, cokernel_epi );
    
    return Kernel( product_morphism );
    
end );

##
RedispatchOnCondition( CotangentSheaf, true, [ IsToricVariety ], [ IsOrbifold ], 0 );

##
RedispatchOnCondition( CotangentSheaf, true, [ IsToricVariety ], [ HasNoTorusfactor ], 0 );

##################################
##
## Methods
##
##################################

##
InstallMethod( UnderlyingSheaf,
               " getter for the sheaf",
               [ IsToricVariety ],
               
  function( variety )
    
    if IsBound( variety!.Sheaf ) then
        
        return variety!.Sheaf;
        
    else
        
        Error( "no sheaf\n" );
        
    fi;
    
end );

##
InstallMethod( CoordinateRingOfTorus,
               " for affine convex varieties",
               [ IsToricVariety, IsList ],
               
  function( variety, variables )
    local n, ring, i, relations;
    
    if HasCoordinateRingOfTorus( variety ) then
        
        return CoordinateRingOfTorus( variety );
        
    fi;
    
#     if Length( IsProductOf( variety ) ) > 1 then
#         
#         n := IsProductOf( variety );
#         
#         if ForAll( n, HasCoordinateRingOfTorus ) then
#             
#             ring := Product( List( n, CoordinateRingOfTorus ) );
#             
#             SetCoordinateRingOfTorus( variety, ring );
#             
#             return ring;
#             
#         fi;
#     
#     fi;
    
    n := Dimension( variety );
    
    if ( not Length( variables ) = 2 * n ) and ( not Length( variables ) = n ) then
        
        Error( "incorrect number of indets\n" );
        
    fi;
    
    if Length( variables ) = n then
        
        variables := List( variables, i -> [ i, JoinStringsWithSeparator( [i,"_"], "" ) ] );
        
        variables := List( variables, i -> JoinStringsWithSeparator( i, "," ) );
        
    fi;
    
    variables := JoinStringsWithSeparator( variables );
    
    ring := DefaultFieldForToricVarieties() * variables;
    
    variables := Indeterminates( ring );
    
    relations := [ 1..n ];
    
    for i in [ 1 .. n ] do
        
        relations[ i ] := variables[ 2*i - 1 ] * variables[ 2*i ] - 1;
        
    od;
    
    ring := ring / relations;
    
    SetCoordinateRingOfTorus( variety, ring );
    
    return ring;
    
end );

##
InstallMethod( CoordinateRingOfTorus,
               " for toric varieties and a string",
               [ IsToricVariety, IsString ],
               
  function( variety, string )
    local variable;
    
    variable := SplitString( string, "," );
    
    if Length( variable ) = 1 then
        
        TryNextMethod();
        
    fi;
    
    return CoordinateRingOfTorus( variety, variable );
    
end );

##
InstallMethod( CoordinateRingOfTorus,
               " for toric varieties and a string",
               [ IsToricVariety, IsString ],
               
  function( variety, string )
    local variable_list;
    
    variable_list := Dimension( variety );
    
    variable_list := List( [ 1 .. variable_list ], i -> JoinStringsWithSeparator( [ string, i ], "" ) );
    
    return CoordinateRingOfTorus( variety, variable_list );
    
end );

##
InstallMethod( ListOfVariablesOfCoordinateRingOfTorus,
               "for toric varieties with cox rings",
               [ IsToricVariety ],
               
  function( variety )
    local coord_ring, variable_list, string_list, i;
    
    if not HasCoordinateRingOfTorus( variety ) then
        
        Error( "no cox ring has no variables\n" );
        
    fi;
    
    coord_ring := CoordinateRingOfTorus( variety );
    
    variable_list := Indeterminates( coord_ring );
    
    string_list := [ ];
    
    for i in variable_list do
        
        Add( string_list, String( i ) );
        
    od;
    
    return string_list;
    
end );

##
InstallMethod( \*,
               "for toric varieties",
               [ IsFanRep, IsFanRep ],
               
  function( variety1, variety2 )
    local product_variety;
  
    product_variety := rec( WeilDivisors := WeakPointerObj( [ ] ) );
    
    ObjectifyWithAttributes( product_variety, TheTypeFanToricVariety 
                            );
    
    SetIsProductOf( product_variety, Flat( [ IsProductOf( variety1 ), IsProductOf( variety2 ) ] ) );
    
    return product_variety;
    
end );

##
InstallMethod( CharacterToRationalFunction,
               "for toric varieties",
               [ IsHomalgElement, IsToricVariety ],
               
  function( character, variety )
    
    return CharacterToRationalFunction( UnderlyingListOfRingElements( character ), variety );
    
end );

##
InstallMethod( CharacterToRationalFunction,
               " for toric varieties",
               [ IsList, IsToricVariety ],
               
  function( character, variety )
    local ring, generators_of_ring, rational_function, i;
    
    if not HasCoordinateRingOfTorus( variety ) then
        
        Error( "cannot compute rational function without coordinate ring of torus, please specify first\n");
        
        return 0;
        
    fi;
    
    ring := CoordinateRingOfTorus( variety );
    
    generators_of_ring := ListOfVariablesOfCoordinateRingOfTorus( variety );
    
    rational_function := "1";
    
    for i in [ 1 .. Length( generators_of_ring )/2 ] do
        
        if character[ i ] < 0 then
            
            rational_function := JoinStringsWithSeparator( [ rational_function , 
                                                             JoinStringsWithSeparator( [ generators_of_ring[ 2 * i ], String( - character[ i ] ) ], "^" ) ],
                                                              "*" );
            
        else
            
            rational_function := JoinStringsWithSeparator( [ rational_function ,
                                                            JoinStringsWithSeparator( [ generators_of_ring[ 2 * i -1 ], String( character[ i ] ) ], "^" ) ],
                                                            "*" );
            
        fi;
        
    od;
    
    return HomalgRingElement( rational_function, ring );
    
end );

##
InstallMethod( TorusInvariantPrimeDivisors,
               " for toric varieties",
               [ IsToricVariety ],
               
  function( variety )
    local divisors;
    
    divisors := TorusInvariantDivisorGroup( variety );
    
    divisors := GeneratingElements( divisors );
    
    Apply( divisors, i -> Divisor( i, variety ) );
    
    List( divisors, function( j ) SetIsPrimedivisor( j, true ); return 0; end );
    
    return divisors;
    
end );

##
InstallMethod( WeilDivisorsOfVariety,
               " for toric varieties",
               [ IsToricVariety ],
               
  function( variety )
    
    return variety!.WeilDivisors;
    
end );

##
InstallMethod( EQ,
               "for toric varieties",
               [ IsToricVariety, IsToricVariety ],
               
  function( variety1, variety2 )
    
    return IsIdenticalObj( variety1, variety2 );
    
end );

##
InstallMethod( Fan,
               " for toric varieties",
               [ IsToricVariety ],
               
  function( variety )
    
    return FanOfVariety( variety );
    
end );

##
InstallMethod( Factors,
               "for toric varieties",
               [ IsToricVariety ],
               
  IsProductOf
  
);

##
InstallMethod( BlowUpOnIthMinimalTorusOrbit,
               "for toric varieties",
               [ IsToricVariety, IsInt ],
               
  function( variety, i )
    local new_vari;
    
    new_vari := ToricVariety( StarSubdivisionOfIthMaximalCone( FanOfVariety( variety ), i ) );
    
    return new_vari;
    
end );

##################################
##
## Constructors
##
##################################

##
InstallMethod( ToricVariety,
               " for homalg fans",
               [ IsFan ],
               
  function( fan )
    local variety;
    
    if not IsPointed( fan ) then
        
        Error( "input fan must only contain strictly convex cones\n" );
        
    fi;
    
    variety := rec( WeilDivisors := WeakPointerObj( [ ] ) );
    
    ObjectifyWithAttributes(
                             variety, TheTypeFanToricVariety,
                             FanOfVariety, fan
                            );
    
    return variety;
    
end );

#################################
##
## InfoMethod
##
#################################

##
InstallMethod( NameOfVariety,
               "for products",
               [ IsToricVariety and HasIsProductOf ],
               
  function( variety )
    local prod;
    
    prod := IsProductOf( variety );
    
    if Length( prod ) = 1 then
        
        TryNextMethod();
        
    fi;
    
    prod := List( prod, NameOfVariety );
    
    return JoinStringsWithSeparator( prod, "*" );
    
end );

##
InstallMethod( NameOfVariety,
               "for toric varieties",
               [ IsToricVariety ],
               
  function( variety )
    local dimension, raygenerators_in_maxcones, raygenerators, i;
    
    dimension := Dimension( variety );
    
    raygenerators := RayGenerators( Fan( variety ) );
    
    if Length( raygenerators ) = 0 then
        
        return "|A^0";
        
    fi;
    
    if IsAffine( variety ) then
        
        if Set( RayGenerators( ConeOfVariety( variety ) ) ) = Set( IdentityMat( dimension ) ) then
            
            dimension := String( dimension );
            
            return JoinStringsWithSeparator( [ "|A^", dimension ], "" );
            
        fi;
        
    fi;
    
    if IsComplete( variety ) then
        
        raygenerators_in_maxcones := List( MaximalCones( FanOfVariety( variety ) ), RayGenerators );
        
        raygenerators_in_maxcones := Set( List( raygenerators_in_maxcones ), Set );
        
        raygenerators := Set( IdentityMat( dimension ) );
        
        Add( raygenerators, - Sum( raygenerators ) );
        
        raygenerators := Combinations( raygenerators, dimension );
        
        raygenerators := Set( List( raygenerators, Set ) );
        
        if raygenerators = raygenerators_in_maxcones then
            
            return JoinStringsWithSeparator( [ "|P^", String( dimension ) ], "" );
            
        fi;
        
        if dimension = 2 then
            
            raygenerators := Set( [ Set( [ [ 1,0 ], [ 0, 1 ] ] ), Set( [ [ 1,0 ], [ 0,-1 ] ] ) ] );
            
            raygenerators_in_maxcones := Difference( raygenerators_in_maxcones, raygenerators );
            
            if Length( raygenerators_in_maxcones ) = 2 then
                
                if ForAny( raygenerators_in_maxcones, i -> IsSubset( i , [ [ 0, -1 ] ] ) ) and 
                   ForAny( raygenerators_in_maxcones, i -> IsSubset( i , [ [ 0, 1 ] ] ) ) then
                    
                    raygenerators_in_maxcones := Intersection( raygenerators_in_maxcones );
                    
                    if Length( raygenerators_in_maxcones ) = 1 then
                        
                        raygenerators_in_maxcones := raygenerators_in_maxcones[ 1 ];
                        
                        if raygenerators_in_maxcones[ 1 ] = -1 then
                            
                            return JoinStringsWithSeparator( [ "H_", String( raygenerators_in_maxcones[ 2 ] ) ], "" );
                            
                        fi;
                        
                    fi;
                    
                fi;
                
            fi;
            
        fi;
        
    fi;
    
    TryNextMethod();
    
end );

##
InstallOtherMethod( StructureDescription,
               "for toric varieties",
               [ IsToricVariety ],
               
  NameOfVariety
  
);

#################################
##
## Display
##
#################################

##
InstallMethod( ViewObj,
               " for toric varieties",
               [ IsToricVariety ],
               
  function( var )
    local proj;
    
    proj := false;
    
    Print( "<A" );
    
    if HasIsAffine( var ) then
        
        if IsAffine( var ) then
            
            Print( "n affine");
            
        fi;
        
    fi;
    
    if HasIsProjective( var ) then
        
        if IsProjective( var ) then
            
            Print( " projective");
            
            proj := true;
            
        fi;
        
    fi;
    
    if HasIsNormalVariety( var ) then
        
        if IsNormalVariety( var ) then
            
            Print( " normal");
            
        fi;
        
    fi;
    
    if HasIsSmooth( var ) then
        
        if IsSmooth( var ) then
            
            Print( " smooth");
            
        else
            
            Print( " non smooth" );
            
        fi;
        
    fi;
    
    if HasIsComplete( var ) then
        
        if IsComplete( var ) then
            
            if not proj then
                
                Print( " complete");
                
            fi;
            
        fi;
        
    fi;
    
    if IsToricSubvariety( var ) then
        
        Print( " toric subvariety" );
        
    else
        
        Print( " toric variety" );
        
    fi;
    
    if HasDimension( var ) then
        
        Print( " of dimension ", Dimension( var ) );
        
    fi;
    
    if HasHasTorusfactor( var ) then
        
        if HasTorusfactor( var ) then
            
            Print(" with a torus factor of dimension ", DimensionOfTorusfactor( var ) );
            
        fi;
        
    
    fi;
    
    if HasIsProductOf( var ) then
        
        if Length( IsProductOf( var ) ) > 1 then
            
            Print(" which is a product of ", Length( IsProductOf( var ) ), " toric varieties" );
            
        fi;
        
    fi;
    
    Print( ">" );
    
end );

##
InstallMethod( Display,
               " for toric varieties",
               [ IsToricVariety ],
               
  function( var )
    local proj;
    
    proj := false;
    
    Print( "A" );
    
    if HasIsAffine( var ) then
        
        if IsAffine( var ) then
            
            Print( "n affine");
            
        fi;
        
    fi;
    
    if HasIsProjective( var ) then
        
        if IsProjective( var ) then
            
            Print( " projective");
            
            proj := true;
            
        fi;
        
    fi;
    
    if HasIsNormalVariety( var ) then
        
        if IsNormalVariety( var ) then
            
            Print( " normal");
            
        fi;
        
    fi;
    
    if HasIsSmooth( var ) then
        
        if IsSmooth( var ) then
            
            Print( " smooth");
            
        else
            
            Print( " non smooth" );
            
        fi;
        
    fi;
    
    if HasIsComplete( var ) then
        
        if IsComplete( var ) then
            
            if not proj then
                
                Print( " complete");
                
            fi;
            
        fi;
        
    fi;
    
    if IsToricVariety( var ) and not IsToricSubvariety( var ) then
        
        Print( " toric variety" );
        
    elif IsToricSubvariety( var ) then
        
        Print( " toric subvariety" );
        
    fi;
    
    if HasDimension( var ) then
        
        Print( " of dimension ", Dimension( var ) );
        
    fi;
    
    if HasHasTorusfactor( var ) then
        
        if HasTorusfactor( var ) then
            
            Print(" with a torus factor of dimension ", DimensionOfTorusfactor( var ) );
            
        fi;
        
    
    fi;
    
    if HasIsProductOf( var ) then
        
        if Length( IsProductOf( var ) ) > 1 then
            
            Print(" which is a product of ", Length( IsProductOf( var ) ), " toric varieties" );
            
        fi;
        
    fi;
    
    Print( ".\n" );
    
    if HasCoordinateRingOfTorus( var ) then
        
        Print( " The torus of the variety is ", CoordinateRingOfTorus( var ),".\n" );
        
    fi;
    
    if HasClassGroup( var ) then
        
        Print( " The class group is ", ClassGroup( var ) );
        
        if HasCoxRing( var ) then
            
            Print( " and the Cox ring is ", CoxRing( var ) );
            
        fi;
        
        Print( ".\n" );
        
    fi;
    
    if HasPicardGroup( var ) then
        
        Print( "The Picard group is ", PicardGroup( var ) );
        
    fi;
    
end );
