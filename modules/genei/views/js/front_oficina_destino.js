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
setTimeout(function () {

    function cargar_mapa_mondial_relay() {
        $.getScript('https://widget.mondialrelay.com/parcelshop-picker/jquery.plugin.mondialrelay.parcelshoppicker.min.js', function () {
            function mapa_mondial_relay_destino(codigo, countrycode) {
                $("#map").MR_ParcelShopPicker({
                    Target: "#Target_Widget_destino"
                    , TargetDisplay: "#TargetDisplay_Widget_destino"
                    , TargetDisplayInfoPR: "#TargetDisplayInfoPR_Widget_destino"
                    , Brand: "MRCANMER"
                    , Country: countrycode
                    , PostCode: codigo
                    , ColLivMod: "24R"
                    , NbResults: "15"
                    , SearchDelay: "15"
                    , DisplayMapInfo: true
                    , OnParcelShopSelected:
                            function (data) {
                                $("#id_delivery_point").val(data.ID);
                            }
                });
            }
            array_mondial_relay_carriers.forEach(function (id_carrier) {
                var codigo = prestashop['customer']['addresses'][$('input[name="id_address_delivery"]').val()]['postcode'];
                var countrycode = prestashop['customer']['addresses'][$('input[name="id_address_delivery"]').val()]['country_iso'];
                mapa_mondial_relay_destino(codigo, countrycode);
            });
            posicionarMapa(array_mondial_relay_carriers)
        });
    }


    function cargar_mapa(id_carrier) {
        $("#id_delivery_point").val(0);
        $('#bring_correos_express').attr('checked', false);
        $('#div_checkbox_correos_express').hide();
        function posicionarMapa(array_uap, array_lista_oficinas) {
            var markers = [];
            var bounds = new google.maps.LatLngBounds();
            var i = 0;

            var map = new google.maps.Map(document.getElementById("map"), {
                zoom: 14,
                center: {lat: array_uap[array_lista_oficinas[0]]["lat"], lng: array_uap[array_lista_oficinas[0]]["long"]}
            });

            var infowindow = new google.maps.InfoWindow({
            });
            array_lista_oficinas.forEach(function (uap) {
                latitud = array_uap[uap]["lat"];
                longitud = array_uap[uap]["long"];

                markers[i] = new google.maps.Marker(
                        {position: {lat: latitud, lng: longitud},
                            map: map, title: array_uap[uap]["title"]});                
                markers[i].addListener('click', function () {
                    $('#id_delivery_point').val(array_uap[uap]["location_id"]);
                    map.panTo(this.getPosition());
                    infowindow.setContent(this.get('title'));
                    infowindow.open(map, this);
                });
                i++;
            });

            google.maps.event.addListenerOnce(map, 'bounds_changed', function (event) {

                this.setZoom(13);


            });           


            if ($('#id_delivery_point').val() == 0 || !array_lista_oficinas.includes($('#id_delivery_point').val())) {
                google.maps.event.trigger(markers[0], 'click');
            } else {
                google.maps.event.trigger(markers[array_lista_oficinas.indexOf($('#id_delivery_point').val())], 'click');
            }
        }
        id_carrier = parseInt(id_carrier);
        $('#map').show();
        $('#div_choose_delivery_point').show();
        $('#modal_mapas_oficina_ok').show();
        if (array_mondial_relay_carriers.includes(id_carrier))
        {
            $('#modal_mapas_oficina').modal('show');
            cargar_mapa_mondial_relay();
            $('<input type="hidden" class="form-control" name="id_delivery_point" id="id_delivery_point" value = "' + id_delivery_point + '" />').insertBefore(delivery_options_element);
        }
        if (array_ups_access_point_carriers.includes(id_carrier)) {
            $('#modal_mapas_oficina').modal('show');
            posicionarMapa(array_oficinas_ups, array_oficinas_ups_list);
            $('<input type="hidden" class="form-control" name="id_delivery_point" id="id_delivery_point" value = "' + id_delivery_point + '" />').insertBefore(delivery_options_element);
        }
        if (array_correos_oficina_carriers.includes(id_carrier)) {
            $('#modal_mapas_oficina').modal('show');
            posicionarMapa(array_oficinas_correos, array_oficinas_correos_list);
            $('<input type="hidden" class="form-control" name="id_delivery_point" id="id_delivery_point" value = "' + id_delivery_point + '" />').insertBefore(delivery_options_element);
        }
        if (array_correos_express_oficina_carriers.includes(id_carrier)) {
            $('#modal_mapas_oficina').modal('show');
            $('#map').hide();
            $('#div_choose_delivery_point').hide();
            $('#modal_mapas_oficina_ok').hide();
            $('#div_checkbox_correos_express').show();
            posicionarMapa(array_oficinas_correos_express, array_oficinas_correos_express_list);
            $('<input type="hidden" class="form-control" name="id_delivery_point" id="id_delivery_point" value = "' + id_delivery_point + '" />').insertBefore(delivery_options_element);
        }



    }


    id_delivery_point = 0;
    var delivery_options_element = '.delivery-options';
    if ($('.delivery_options')[0]) {
        delivery_options_element = '.delivery_options';
    }

    $(document).ready(function () {
        $('input[id^=delivery_option_]').each(function () {
            if ($(this).is(':checked')) {
             //   cargar_mapa($(this).val().split(',')[0].trim());
            }
        });

        $('input[id^=delivery_option_]').click(function () {
            cargar_mapa($(this).val().split(',')[0].trim());
        });

        $('[aria-label="Close"]').click(function () {
            $('#modal_mapas_oficina').modal('hide');

        });
        setTimeout(function () {
            $(".dismissButton").on("click", function () {
                $('#modal_mapas_oficina').modal('hide');
            });
        }, 2000);

        $("#modal_mapas_oficina_ok").click(function (e) {
            $('#modal_mapas_oficina').modal('hide');
        });

        $("#bring_correos_express").on("click", function () {
            $('#map').show();
            $('#div_choose_delivery_point').show();
            $('#modal_mapas_oficina_ok').show();            
        });
        
        $("#no_bring_correos_express").on("click", function () {
            $("#id_delivery_point").val(0);
            $('#modal_mapas_oficina').modal('hide');
        });
    

    });
}, 1000);


