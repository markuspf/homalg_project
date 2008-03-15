LoadPackage( "HomalgRings" );
HOMALG_RINGS.color_display := true;
maple_stream := LaunchMaple9( );
init := HomalgExternalObject( "", "Maple", maple_stream );
HomalgSendBlocking( "with(PIR): with(homalg)", "execute_command", init );
RPP := HomalgSendBlocking( "`PIR/homalg`", init );
Unbind(init);
HomalgSendBlocking( [ "homalg_options(", RPP, ")" ], "execute_command" );
ZZ := HomalgSendBlocking( [ "[],", RPP ], IsHomalgPIRMapleRing );
ZZ := RingForHomalg( ZZ );
Display(ZZ);
wmat := HomalgSendBlocking( "matrix([[ 262, -33, 75, -40 ], [ 682, -86, 196, -104 ], [ 1186, -151, 341, -180 ], [ -1932, 248, -556, 292 ], [ 1018, -127, 293, -156 ]])", ZZ );
wmat := HomalgMatrix( wmat, ZZ );
wrel := HomalgRelationsForLeftModule( wmat );
W := Presentation( wrel );
