{**
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
*}

<script type="text/javascript">
    
      function desactivar_activar_atributos()
    {
        if($('#atributos_defecto_genei_default').val() == '0')
        {
            $('#peso_defecto_genei').prop('disabled', true);
            $('#largo_defecto_genei').prop('disabled', true);
            $('#alto_defecto_genei').prop('disabled', true);
            $('#ancho_defecto_genei').prop('disabled', true);
            $('#num_bultos_defecto_genei').prop('disabled', true);
        }    
    else
        {
            $('#peso_defecto_genei').prop('disabled', false);
            $('#largo_defecto_genei').prop('disabled', false);
            $('#alto_defecto_genei').prop('disabled', false);
            $('#ancho_defecto_genei').prop('disabled', false);
            $('#num_bultos_defecto_genei').prop('disabled', false);
        }
    }
$(document).ready(function()  
{      
    {if {$estado_autenticacion_genei|escape:'htmlall':'UTF-8'} == "1"} 
            if (typeof ($("#transportistas_utilizados_genei_variacion").val()) != "undefined")
                obtener_variaciones_precio_transportista();
    {/if}
    
    $('#id_pais_registro').change(function() {
        if ($('#id_pais_registro').val() == 7 && $('#tipo_registro_particular').is(':checked')){
            $('#div_nif_cif_registro').hide();
        }else{
            $('#div_nif_cif_registro').show();
        }
    });
    $('input:radio[name=tipo_registro]').change(function () {
        if ($('#id_pais_registro').val() == 7 && $('#tipo_registro_particular').is(':checked')){
            $('#div_nif_cif_registro').hide();
        }else{
            $('#div_nif_cif_registro').show();
        }
    });
    
    if($('#transportistas_no_utilizados_genei > option').length > 0)
        $('#boton_aniadir_transportista_genei').prop('disabled', false);
    else
        $('#boton_aniadir_transportista_genei').prop('disabled', true);
     if($('#transportistas_utilizados_genei > option').length > 0)
        $('#boton_eliminar_transportista_genei').prop('disabled', false);
    else
        $('#boton_eliminar_transportista_genei').prop('disabled', true);
    $(".chosen-select").chosen();
    desactivar_activar_atributos();
$('#atributos_defecto_genei_default').change(function() {
    desactivar_activar_atributos();
});
{if {$estado_autenticacion_genei|escape:'htmlall':'UTF-8'} == "1"}
        $('#boton_logout_genei').show();
        $('#boton_registrarse_genei').hide();
        $('#capa_direccion_predeterminada_genei').show();
        $('#boton_login_genei').hide();
{else}        
    $('#boton_logout_genei').hide();
    $('#boton_login_genei').show();
    $('#boton_registrarse_genei').show();
    $('#capa_direccion_predeterminada_genei').hide();
{/if}
});
function mostrar_advertencia_cache()
{
    $('#modal_advertencia_cache').modal('show');
}

function obtener_variaciones_precio_transportista()
{
    url_obtener_variaciones_precio_transportista = "{$geneiajaxcontrollerlink|escape:'htmlall':'UTF-8'}&action=obtener_variaciones_precio_transportista";
     $.ajax({
        type: "POST",
        url: url_obtener_variaciones_precio_transportista,
        data: {
         datos_json_obtener_variaciones_precio_transportista:JSON.stringify($("#transportistas_utilizados_genei_variacion").val()),
     }
     })
    .done(function(data, textStatus, jqXHR){
    $('#div_espera').hide();  
    salida=$.parseJSON(data);
    $("#variation_price_amount_genei").val(salida.price_variation);
    $("#variation_amount_free_genei").val(salida.amount_free);
    $("#variation_type_genei").val(salida.variation_type);    
});
}

function instalar_transportista()
{   
    $('#boton_aniadir_transportista_genei').prop('disabled', true);    
    $('#boton_aniadir_transportista_genei').html('{l mod='genei' s ='Please wait...'}');
    $('#div_espera').html('<span style="color:red;">{*l mod='genei' s ='Retrieving pick-up information ....'*}</span>');
    $('#div_espera').show();  
    url_instalar_transportista = "{$geneiajaxcontrollerlink|escape:'htmlall':'UTF-8'}&action=instalar_transportista_genei";
     $.ajax({
        type: "POST",
        url: url_instalar_transportista,
        data: {
         datos_json_instalar_transportista_genei:JSON.stringify($("#transportistas_no_utilizados_genei").val()),
     }
    })
    .done(function(data, textStatus, jqXHR){
    $('#div_carrier_uninstalled_genei').show();
    $("#datos_guardados_genei" ).val(1);
    $("#form_configuration_genei" ).submit();
});
}

function desinstalar_transportista()
{    
    $('#boton_eliminar_transportista_genei').prop('disabled', true);    
    $('#boton_eliminar_transportista_genei').html('{l mod='genei' s ='Please wait...'}');
    $('#div_espera').html('<span style="color:red;">{l mod='genei' s ='Retrieving pick-up information ....'}</span>');
    $('#div_espera').show();  
    url_desinstalar_transportista = "{$geneiajaxcontrollerlink|escape:'htmlall':'UTF-8'}&action=desinstalar_transportista_genei";
     $.ajax({
        type: "POST",
        url: url_desinstalar_transportista,
        data: {
         datos_json_desinstalar_transportista_genei:JSON.stringify($("#transportistas_utilizados_genei").val()),
     }
    })
    .done(function(data, textStatus, jqXHR){
    $('#div_carrier_installed_genei').show();
    $("#datos_guardados_genei" ).val(1);    
    $("#form_configuration_genei" ).submit();
});
}
function ver_mensaje_terminos_y_condiciones() {
        datos = { }   
     $.ajax({
        type: "POST",
        url: "{$current|escape:'htmlall':'UTF-8'}&token={$token|escape:'htmlall':'UTF-8'}&terminos_condiciones_genei",
        data: {
         datos_json_terminos_condiciones_genei:JSON.stringify(datos),
     }
    })
    .done(function(data, textStatus, jqXHR){
    salida=$.parseJSON(data);                    
    $('#body_terminos_genei').html(salida.terminos_condiciones)
    $('#modal_terminos_y_condiciones_genei').modal('show');
    
});
    }
    
function abrir_registro()
{       
       $('#modal_registrar').modal('show');
}

function isValidCif(abc){
	par = 0;
	non = 0;
	letras = "ABCDEFGHKLMNPQS";
	let = abc.charAt(0);
 
	if (abc.length!=9) {
		//alert('El Cif debe tener 9 dígitos');
		return false;
	}
 
	if (letras.indexOf(let.toUpperCase())==-1) {
		//alert("El comienzo del Cif no es válido");
		return false;
	}
 
	for (zz=2;zz<8;zz+=2) {
		par = par+parseInt(abc.charAt(zz));
	}
 
	for (zz=1;zz<9;zz+=2) {
		nn = 2*parseInt(abc.charAt(zz));
		if (nn > 9) nn = 1+(nn-10);
		non = non+nn;
	}
 
	parcial = par + non;
	control = (10 - ( parcial % 10));
	if (control==10) control=0;
 
	if (control!=abc.charAt(8)) {
		//alert("El Cif no es válido");
		return false;
	}
	//alert("El Cif es válido");
	return true;
}

function isValidNif(abc){
	dni=abc.substring(0,abc.length-1);
	let=abc.charAt(abc.length-1);
	if (!isNaN(let)) {
		//alert('Falta la letra');
		return false;
	}else{
		cadena = "TRWAGMYFPDXBNJZSQVHLCKET";
		posicion = dni % 23;
		letra = cadena.substring(posicion,posicion+1);
		if (letra!=let.toUpperCase()){
			//alert("Nif no válido");
			return false;
		}
	}
	//alert("Nif válido")
	return true;
}

function comprobar_email(email) {
    var pattern = /^([a-z\d!#$%&'*+\-\/=?^_`{ |}~\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]+(\.[a-z\d!#$%&'*+\-\/=?^_`{ |}~\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]+)*|"((([ \t]*\r\n)?[ \t]+)?([\x01-\x08\x0b\x0c\x0e-\x1f\x7f\x21\x23-\x5b\x5d-\x7e\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]|\\[\x01-\x09\x0b\x0c\x0d-\x7f\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))*(([ \t]*\r\n)?[ \t]+)?")@(([a-z\d\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]|[a-z\d\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF][a-z\d\-._~\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]*[a-z\d\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])\.)+([a-z\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]|[a-z\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF][a-z\d\-._~\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]*[a-z\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])\.?$/i;
    return pattern.test(email);
};
function enviar_registro_genei()
{
    $('#boton_enviar_registro_genei').prop('disabled', false);
    $('#capa_informacion_registro').hide();        
    if($('#nombre_registro').val()==''        
        || ($('#nif_cif_registro').val()==''
        && $('#id_pais_registro').val() != 7)
        || $('#telefono_registro').val()==''
        || $('#email_registro').val()==''
        || $('#codigo_postal_registro').val()==''
        || $('#direccion_registro').val()==''
        || $('#id_pais_registro').val()==''
        || $('#provincia_registro').val()==''
        || $('#poblacion_registro').val()==''
        || $('#pwd_registro').val()=='') {
        $('#capa_informacion_registro').html('{l mod='genei' s ='You must fill all fields'}');
        $('#capa_informacion_registro').show();
        return;    
    }
    if(!comprobar_email($('#email_registro').val()))
    {
        $('#capa_informacion_registro').html('{l mod='genei' s ='invalid Email'}');
        $('#capa_informacion_registro').show();        
        return;    
    }
    if($('#id_pais_registro').val() == 1)
    {    
        if(!isValidNif($('#nif_cif_registro').val()))
        {
            $('#capa_informacion_registro').html('{l mod='genei' s ='Invalid NIF/NIE'}');
            $('#capa_informacion_registro').show();    
            return;    
        }
    }    
    if($('#pwd_registro').val().length < 5)
    {
        $('#capa_informacion_registro').html('{l mod='genei' s ='Password too short'}');
        $('#capa_informacion_registro').show();        
        return;    
    }
    if($("#condiciones_registro").attr('checked')!="checked") 
    {
        $('#capa_informacion_registro').html('{l mod='genei' s ='You must accept terms of service'}');
        $('#capa_informacion_registro').show();        
        return;    
    }
    $('#capa_informacion_registro').hide();
    $('#boton_enviar_registro_genei').prop('disabled', true);    
    $('#boton_enviar_registro_genei').html('{l mod='genei' s ='Please wait...'}');
    url_registro="{$geneiajaxcontrollerlink|escape:'htmlall':'UTF-8'}&action=registro_genei";
    datos = {                
        'nombre_registro': $('#nombre_registro').val(),
        'nif_cif_registro': $('#nif_cif_registro').val(),
        'telefono_registro': $('#telefono_registro').val(),
        'email_registro': $('#email_registro').val(),
        'codigo_postal_registro': $('#codigo_postal_registro').val(),
        'direccion_registro': $('#direccion_registro').val(),
        'id_pais': $('#id_pais_registro').val(),
        'provincia_registro': $('#provincia_registro').val(),
        'poblacion_registro': $('#poblacion_registro').val(),
        'pwd_registro': $('#pwd_registro').val(),
    }    
    $('#div_espera').html('<span style="color:red;">{l mod='genei' s ='Retrieving pick-up information ....'}</span>');
    $('#registrarse').prop('disabled', true);
    $('#registrarse').html('{l mod='genei' s ='Please wait...'}');
    $('#div_espera').show();    
     $.ajax({
        type: "POST",
        
        url: url_registro,
        data: {
         datos_json_registro_genei:JSON.stringify(datos),
     }
    })
    .done(function(data, textStatus, jqXHR){
    salida=$.parseJSON(data); 
    if (salida.resultado!=1)
    {
        $('#capa_informacion_registro').html(salida.error);
        $('#capa_informacion_registro').show();        
        $('#boton_enviar_registro_genei').prop('disabled', false);        
        $('#boton_enviar_registro_genei').html('{l mod='genei' s ='Register'}');
        return;
    }
    else
    {
        $('#modal_registro_ok').modal('show');
        $('#modal_registrar').modal('hide');        
    }
    
});

}

function establecer_direccion_predeterminada_genei()
{
    $("#form_configuration_genei").submit();
}
function login_genei()
{      
    $('#capa_informacion_login').hide();
    url_login="{$geneiajaxcontrollerlink|escape:'htmlall':'UTF-8'}&action=login_genei";
    $('#usuario_servicio_genei').prop('disabled', true);
    $('#password_servicio_genei').prop('disabled', true);
    $('#boton_login_genei').prop('disabled', true);     
    if($('#usuario_servicio_genei').val()==''            
        || $('#password_servicio_genei').val()=='') {                
        $('#usuario_servicio_genei').attr('placeholder', '{l s='User can not be empty' mod='genei'}');
        $('#password_servicio_genei').attr('placeholder', '{l s='Password can not be empty' mod='genei'}');
        $('#div_resultado_ko_login_genei').show();        
        $('#usuario_servicio_genei').prop('disabled', false);
    $('#password_servicio_genei').prop('disabled', false);
    $('#boton_login_genei').prop('disabled', false);     
        return;    
    }
    $('#boton_login_genei').html('{l mod='genei' s ='Please wait...'}');
    datos = {                
        'usuario_servicio': $('#usuario_servicio_genei').val(),
        'password_servicio': $('#password_servicio_genei').val()
    }        
     $.ajax({
        type: "POST",
        url: url_login,
        data: {
         datos_json_registro_genei:JSON.stringify(datos),
     }
    })
    .done(function(data, textStatus, jqXHR){
    salida=$.parseJSON(data); 
    $('#boton_login_genei').prop('disabled', false);
    $('#boton_login_genei').html('{l mod='genei' s ='Login'}');
    $('#boton_logout_genei').html('{l mod='genei' s ='Logout'}');
    if (salida.resultado!=1)
    {
        $('#boton_registrarse_genei').show();
        $('#usuario_servicio_genei').prop('disabled', false);
        $('#password_servicio_genei').prop('disabled', false);
        $('#div_resultado_ko_login_genei').html('{l s='Invalid login' mod='genei'}')
        $('#div_resultado_ko_login_genei').show();        
        return;
    }
    else
    {   
        $('#div_resultado_ko_login_genei').hide();
        $('#div_resultado_ok_login_genei').show();
        $('#usuario_servicio_genei').prop('disabled', true);
        $('#password_servicio_genei').prop('disabled', true);
        $('#boton_registrarse_genei').hide();                
        $('#boton_login_genei').hide();
        $('#boton_logout_genei').show();        
        
        if($(salida.array_direcciones_formateado).length == 0)
        {
            $('#capa_errores_direcciones').show();            
            $('#capa_informacion_login').hide();
            url_logout="{$geneiajaxcontrollerlink|escape:'htmlall':'UTF-8'}&action=logout_genei";    
            $('#boton_logout_genei').prop('disabled', true);   
            $('#boton_logout_genei').html('{l mod='genei' s ='Please wait...'}');
            datos = {                
                'usuario_servicio': $('#usuario_servicio_genei').val(),
                'password_servicio': $('#password_servicio_genei').val()        
            }        
             $.ajax({
                type: "POST",
                url: url_logout,
                data: {
                 datos_json_registro_genei:JSON.stringify(datos),
             }
            })
            .done(function(data, textStatus, jqXHR){
                $('#div_resultado_ok_login_genei').hide();
                $('#div_resultado_ok_logout_genei').show();
                $('#boton_logout_genei').hide();
                $('#boton_login_genei').show();
                $('#boton_registrarse_genei').show();
                $('#usuario_servicio_genei').val('')
                $('#password_servicio_genei').val('');
                $('#usuario_servicio_genei').attr('placeholder', '{l s='Please enter user' mod='genei'}');                
                $('#password_servicio_genei').attr('placeholder', '{l s='Please enter password' mod='genei'}');

         });
        }
        
        $(salida.array_direcciones_formateado).each(function(i,val){
        $.each(val,function(k,v){        
        $('#direccion_predeterminada_genei').append($('<option>', { 
        value: k,
        text : v        
    }));
    });
     });
   
        $('#capa_direccion_predeterminada_genei').show();        
        $('#direccion_predeterminada_genei').show();        
    }
    
});

}

function logout_genei()
{      
    $('#capa_informacion_login').hide();
    url_logout="{$geneiajaxcontrollerlink|escape:'htmlall':'UTF-8'}&action=logout_genei";    
    $('#boton_logout_genei').prop('disabled', true);   
    $('#boton_logout_genei').html('{l mod='genei' s ='Please wait...'}');
    datos = {                
        'usuario_servicio': $('#usuario_servicio_genei').val(),
        'password_servicio': $('#password_servicio_genei').val()        
    }        
     $.ajax({
        type: "POST",
        url: url_logout,
        data: {
         datos_json_registro_genei:JSON.stringify(datos),
     }
    })
    .done(function(data, textStatus, jqXHR){
    $("#form_configuration_genei" ).submit();
   
    
});


}
function guardar_configuracion_genei()
{      
    url_guardar_configuracion_genei="{$geneiajaxcontrollerlink|escape:'htmlall':'UTF-8'}&action=guardar_configuracion_genei";    
    if($('#estados_automaticos_pedidos_genei_yes').attr('checked'))    
        estados_automaticos_pedidos_genei = 1;
    else
        estados_automaticos_pedidos_genei = 0;    
    if(typeof array_variation_price_amount_genei == 'undefined')
        array_variation_price_amount_genei = [];
    if(typeof array_variation_amount_free_genei == 'undefined')
        array_variation_amount_free_genei = [];
    if(typeof array_variation_type_genei == 'undefined')
        array_variation_type_genei = [];
    datos = {
        'array_variation_price_amount_genei': array_variation_price_amount_genei,
        'array_variation_amount_free_genei': array_variation_amount_free_genei,
        'array_variation_type_genei': array_variation_type_genei,
        'usuario_servicio': $('#usuario_servicio_genei').val(),
        'password_servicio': $('#password_servicio_genei').val(),
        'metodo_pago_contrareembolso_defecto_genei_default': $('#metodo_pago_contrareembolso_defecto_genei_default').val(),
        'atributos_defecto_genei_default': $('#atributos_defecto_genei_default').val(),
        'peso_defecto_genei': $('#peso_defecto_genei').val(),
        'largo_defecto_genei': $('#largo_defecto_genei').val(),
        'ancho_defecto_genei': $('#ancho_defecto_genei').val(),
        'alto_defecto_genei': $('#alto_defecto_genei').val(),
        'num_bultos_defecto_genei': $('#num_bultos_defecto_genei').val(),
        'estado_recogida_tramitada_genei_default': $('#estado_recogida_tramitada_genei_default').val(),
        'estado_envio_transito_genei_default': $('#estado_envio_transito_genei_default').val(),
        'estado_envio_incidencia_genei_default': $('#estado_envio_incidencia_genei_default').val(),
        'estado_envio_entregado_genei_default': $('#estado_envio_entregado_genei_default').val(),
        'estados_automaticos_pedidos_genei': estados_automaticos_pedidos_genei,        
        'variation_type_genei': $('#variation_type_genei').val(),   
        'google_api_key': $('#google_api_key').val(),
        'transportistas_utilizados_genei_variacion': $('#transportistas_utilizados_genei_variacion').val(),        
        'variation_price_amount_genei': $('#variation_price_amount_genei').val(),    
        'variation_amount_free_genei': $('#variation_amount_free_genei').val(),    
        'direccion_predeterminada_genei': $('#direccion_predeterminada_genei').val()        
    }        
     $.ajax({
        type: "POST",
        url: url_guardar_configuracion_genei,
        data: {
         datos_json_guardar_configuracion_genei:JSON.stringify(datos),
     }
    })
    .done(function(data, textStatus, jqXHR){
        $("#datos_guardados_genei" ).val(1);
        $("#form_configuration_genei" ).submit();
});
}
</script>