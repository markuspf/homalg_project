#############################################################################
##
##  HomalgSpectralSequence.gd   homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Declaration stuff for homalg spectral sequences.
##
#############################################################################

####################################
#
# categories:
#
####################################

# a new GAP-category:

##  <#GAPDoc Label="IsHomalgSpectralSequence">
##  <ManSection>
##    <Filt Type="Category" Arg="E" Name="IsHomalgSpectralSequence"/>
##    <Returns>true or false</Returns>
##    <Description>
##      The &GAP; category of &homalg; (co)homological spectral sequences. <Br/><Br/>
##      (It is a subcategory of the &GAP; category <C>IsHomalgObject</C>.)
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareCategory( "IsHomalgSpectralSequence",
        IsHomalgObject );

# three new GAP-subcategories:

##  <#GAPDoc Label="IsHomalgSpectralSequenceAssociatedToAnExactCouple">
##  <ManSection>
##    <Filt Type="Category" Arg="E" Name="IsHomalgSpectralSequenceAssociatedToAnExactCouple"/>
##    <Returns>true or false</Returns>
##    <Description>
##      The &GAP; category of &homalg; associated to an exact couple. <Br/><Br/>
##      (It is a subcategory of the &GAP; category <C>IsHomalgSpectralSequence</C>.)
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareCategory( "IsHomalgSpectralSequenceAssociatedToAnExactCouple",
        IsHomalgSpectralSequence );

##  <#GAPDoc Label="IsHomalgSpectralSequenceAssociatedToAFilteredComplex">
##  <ManSection>
##    <Filt Type="Category" Arg="E" Name="IsHomalgSpectralSequenceAssociatedToAFilteredComplex"/>
##    <Returns>true or false</Returns>
##    <Description>
##      The &GAP; category of &homalg; associated to a filtered complex. <Br/>
##      The <M>0</M>-th spectral sheet <M>E_0</M> stemming from a filtration is a bigraded (differential) object,
##      which, in general, does not stem from an exact couple (although <M>E_1</M>, <M>E_2</M>, ... do). <Br/><Br/>
##      (It is a subcategory of the &GAP; category <C>IsHomalgSpectralSequence</C>.)
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareCategory( "IsHomalgSpectralSequenceAssociatedToAFilteredComplex",
        IsHomalgSpectralSequence );

##  <#GAPDoc Label="IsHomalgSpectralSequenceAssociatedToABicomplex">
##  <ManSection>
##    <Filt Type="Category" Arg="E" Name="IsHomalgSpectralSequenceAssociatedToABicomplex"/>
##    <Returns>true or false</Returns>
##    <Description>
##      The &GAP; category of &homalg; associated to a bicomplex. <Br/><Br/>
##      (It is a subcategory of the &GAP; category <Br/>
##       <C>IsHomalgSpectralSequenceAssociatedToAFilteredComplex</C>.)
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareCategory( "IsHomalgSpectralSequenceAssociatedToABicomplex",
        IsHomalgSpectralSequenceAssociatedToAFilteredComplex );

####################################
#
# attributes:
#
####################################

##  <#GAPDoc Label="GeneralizedEmbeddingsInTotalObjects">
##  <ManSection>
##    <Attr Arg="E" Name="GeneralizedEmbeddingsInTotalObjects"/>
##    <Returns>a record containing containing &homalg; maps</Returns>
##    <Description>
##      The generalized embbedings of the objects in the stable sheet into the objects of the associated total complex.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute( "GeneralizedEmbeddingsInTotalObjects",
        IsHomalgSpectralSequence );

##  <#GAPDoc Label="GeneralizedEmbeddingsInTotalDefects">
##  <ManSection>
##    <Attr Arg="E" Name="GeneralizedEmbeddingsInTotalDefects"/>
##    <Returns>a record containing containing &homalg; maps</Returns>
##    <Description>
##      The generalized embbedings of the objects in the stable sheet into the defects of the associated total complex.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute( "GeneralizedEmbeddingsInTotalDefects",
        IsHomalgSpectralSequence );

####################################
#
# global functions and operations:
#
####################################

# constructor methods:

DeclareOperation( "HomalgSpectralSequence",
        [ IsInt, IsHomalgBicomplex, IsInt ] );

DeclareOperation( "HomalgSpectralSequence",
        [ IsInt, IsHomalgBicomplex ] );

DeclareOperation( "HomalgSpectralSequence",
        [ IsHomalgBicomplex, IsInt ] );

DeclareOperation( "HomalgSpectralSequence",
        [ IsHomalgBicomplex ] );

# basic operations:

DeclareOperation( "homalgResetFilters",
        [ IsHomalgSpectralSequence ] );

DeclareOperation( "PositionOfTheDefaultSetOfRelations",
        [ IsHomalgSpectralSequence ] );			## provided to avoid branching in the code and always returns fail

DeclareOperation( "LevelsOfSpectralSequence",
        [ IsHomalgSpectralSequence ] );

DeclareOperation( "CertainSheet",
        [ IsHomalgSpectralSequence, IsInt ] );

DeclareOperation( "LowestLevelInSpectralSequence",
        [ IsHomalgSpectralSequence ] );

DeclareOperation( "HighestLevelInSpectralSequence",
        [ IsHomalgSpectralSequence ] );

DeclareOperation( "SheetsOfSpectralSequence",
        [ IsHomalgSpectralSequence ] );

DeclareOperation( "LowestLevelSheetInSpectralSequence",
        [ IsHomalgSpectralSequence ] );

DeclareOperation( "HighestLevelSheetInSpectralSequence",
        [ IsHomalgSpectralSequence ] );

DeclareOperation( "ObjectDegreesOfSpectralSequence",
        [ IsHomalgSpectralSequence ] );

DeclareOperation( "CertainObject",
        [ IsHomalgSpectralSequence, IsList, IsInt ] );

DeclareOperation( "CertainObject",
        [ IsHomalgSpectralSequence, IsList ] );

DeclareOperation( "ObjectsOfSpectralSequence",
        [ IsHomalgSpectralSequence, IsInt ] );

DeclareOperation( "ObjectsOfSpectralSequence",
        [ IsHomalgSpectralSequence ] );

DeclareOperation( "LowestBidegreeInSpectralSequence",
        [ IsHomalgSpectralSequence ] );

DeclareOperation( "HighestBidegreeInSpectralSequence",
        [ IsHomalgSpectralSequence ] );

DeclareOperation( "LowestTotalDegreeInSpectralSequence",
        [ IsHomalgSpectralSequence ] );

DeclareOperation( "HighestTotalDegreeInSpectralSequence",
        [ IsHomalgSpectralSequence ] );

DeclareOperation( "TotalDegreesOfSpectralSequence",
        [ IsHomalgSpectralSequence ] );

DeclareOperation( "BidegreesOfSpectralSequence",
        [ IsHomalgSpectralSequence, IsInt ] );

DeclareOperation( "LowestBidegreeObjectInSpectralSequence",
        [ IsHomalgSpectralSequence, IsInt ] );

DeclareOperation( "LowestBidegreeObjectInSpectralSequence",
        [ IsHomalgSpectralSequence ] );

DeclareOperation( "HighestBidegreeObjectInSpectralSequence",
        [ IsHomalgSpectralSequence, IsInt ] );

DeclareOperation( "HighestBidegreeObjectInSpectralSequence",
        [ IsHomalgSpectralSequence ] );

DeclareOperation( "CertainMorphism",
        [ IsHomalgSpectralSequence, IsList, IsInt ] );

DeclareOperation( "CertainMorphism",
        [ IsHomalgSpectralSequence, IsList ] );

DeclareOperation( "UnderlyingBicomplex",
        [ IsHomalgSpectralSequenceAssociatedToABicomplex ] );

DeclareOperation( "AssociatedFilteredComplex",
        [ IsHomalgSpectralSequence ] );

DeclareOperation( "AssociatedFirstSpectralSequence",
        [ IsHomalgSpectralSequence ] );

DeclareOperation( "LevelOfStability",
        [ IsHomalgSpectralSequence, IsList, IsInt ] );

DeclareOperation( "LevelOfStability",
        [ IsHomalgSpectralSequence, IsList ] );

DeclareOperation( "StaircaseOfStability",
        [ IsHomalgSpectralSequence, IsList, IsInt ] );

DeclareOperation( "StaircaseOfStability",
        [ IsHomalgSpectralSequence, IsList ] );

