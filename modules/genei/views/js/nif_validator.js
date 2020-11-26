/*
* 2016 genei
*
* Genei Gestión Logística
*
* NOTICE OF LICENSE
*
*  @author    Genei info@genei.es
*  @copyright 2016 Genei
*  @license   Non-commercial
*  @version 2.0.0
*  
*/
    jQuery.validator.addMethod( "nifES", function ( value, element ) {
 "use strict";
 
 value = value.toUpperCase();
 
 // Basic format test
 if ( !value.match('((^[A-Z]{1}[0-9]{7}[A-Z0-9]{1}$|^[T]{1}[A-Z0-9]{8}$)|^[0-9]{8}[A-Z]{1}$)') ) {
  return false;
 }
 
 // Test NIF
 if ( /^[0-9]{8}[A-Z]{1}$/.test( value ) ) {
  return ( "TRWAGMYFPDXBNJZSQVHLCKE".charAt( value.substring( 8, 0 ) % 23 ) === value.charAt( 8 ) );
 }
 // Test specials NIF (starts with K, L or M)
 if ( /^[KLM]{1}/.test( value ) ) {
  return ( value[ 8 ] === String.fromCharCode( 64 ) );
 }
 
 return false;
 
}, "Please specify a valid NIF number." );
 
 
jQuery.validator.addMethod( "nieES", function ( value, element ) {
 "use strict";
 
 value = value.toUpperCase();
 
 // Basic format test
 if ( !value.match('((^[A-Z]{1}[0-9]{7}[A-Z0-9]{1}$|^[T]{1}[A-Z0-9]{8}$)|^[0-9]{8}[A-Z]{1}$)') ) {
  return false;
 }
 
 // Test NIE
 //T
 if ( /^[T]{1}/.test( value ) ) {
  return ( value[ 8 ] === /^[T]{1}[A-Z0-9]{8}$/.test( value ) );
 }
 
 //XYZ
 if ( /^[XYZ]{1}/.test( value ) ) {
  return (
   value[ 8 ] === "TRWAGMYFPDXBNJZSQVHLCKE".charAt(
    value.replace( 'X', '0' )
     .replace( 'Y', '1' )
     .replace( 'Z', '2' )
     .substring( 0, 8 ) % 23
   )
  );
 }
 
 return false;
 
}, "Please specify a valid NIE number." );
 
 
 
jQuery.validator.addMethod( "cifES", function ( value, element ) {
 "use strict";
  
 var sum,
  num = [],
  controlDigit;
  
 value = value.toUpperCase();
  
 // Basic format test
 if ( !value.match( '((^[A-Z]{1}[0-9]{7}[A-Z0-9]{1}$|^[T]{1}[A-Z0-9]{8}$)|^[0-9]{8}[A-Z]{1}$)' ) ) {
  return false;
 }
  
 for ( var i = 0; i < 9; i++ ) {
  num[ i ] = parseInt( value.charAt( i ), 10 );
 }
  
 // Algorithm for checking CIF codes
 sum = num[ 2 ] + num[ 4 ] + num[ 6 ];
 for ( var count = 1; count < 8; count += 2 ) {
  var tmp = ( 2 * num[ count ] ).toString(),
   secondDigit = tmp.charAt( 1 );
   
  sum += parseInt( tmp.charAt( 0 ), 10 ) + ( secondDigit === '' ? 0 : parseInt( secondDigit, 10 ) );
 }
  
 // CIF test
 if ( /^[ABCDEFGHJNPQRSUVW]{1}/.test( value ) ) {
  sum += '';
  controlDigit = 10 - parseInt( sum.charAt( sum.length - 1 ), 10 );
  value += controlDigit;
  return ( num[ 8 ].toString() === String.fromCharCode( 64 + controlDigit ) || num[ 8 ].toString() === value.charAt( value.length - 1 ) );
 }
  
 return false;
  
}, "Please specify a valid CIF number." );