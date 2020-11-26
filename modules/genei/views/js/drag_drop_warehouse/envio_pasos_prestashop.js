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
    $(function () {
    //let id_usuario = id_usuario_crear_envio;
    
    //Funciones click
    $(document).on('click', '.borrar-bulto-inventario', borrar_bulto_inventario);
    $(document).on('click', '.aniadir-bulto-inventario', {tipo: 'bulto-inventario'}, desplegar_aside);
    $(document).on('click', '.editar-bulto-inventario', {tipo: 'bulto-inventario'}, desplegar_aside);
    $(document).on('click', '.aniadir-bulto-inventario-drop', generar_nuevo_bulto_inventario);
    $(document).on('click', '#cerrar-aside', cerrar_aside);
    $(document).on('click', '.grupo-inventario-fila .icono-desplegar', mostrar_info_grupo_referencias);
    $(document).on('click', '.resta', restar);
    $(document).on('click', '.suma', sumar);
    $(document).on('click', '.caja-bulto-inventario', almacenar_valor_previo);
    $(document).on('click', '#muestra-referencias', mostrar_referencias);
    $(document).on('click', '#muestra-grupos', mostrar_grupos);

    //Funciones change
    $(document).on('change', '.caja-bulto-inventario', quitar_caja_bulto_inventario);

    //Funciones keyup
    $(document).on('keyup', '#filtro_referencias', function (e) {
        if ($('#filtro_referencias').val() == '') {
            //Carga todas las referencias del usuario cuando éste borra la búsqueda
            $('#listado-referencias-inventario').remove();
            cargar_referencias_usuario();
        }
    });
   
    //Funciones focus
    $(document).on('focus', '#filtro_referencias', function (e) {
        //Funcion de autocompletar para el filtrado de referencias
        if (!$(this).data("autocomplete")) { //If the autocomplete wasn't called yet
            $("#filtro_referencias").autocomplete({
                delay: 0,
                autoFocus: true,
                minLength: 4,
                /*
                 select: function (event, ui) { //CARGA LA OPCIÓN SELECCIONADA
                 //Puesto que ahora se muestran los resultados en el menú de elementos draggables ya no es necesario la acción "select"
                 //Ésta tenía lugar cuando los resultados se mostraban en un desplegable bajo el campo de búsqueda y se seleccionaba uno de ellos
                 let busqueda = ui.item.value;
                 let id_busqueda = busqueda.match(/\(([^)]+)\)/)[1];
                 $('#listado-referencias-inventario').remove();
                 cargar_referencias_usuario(id_busqueda, 1);
                 },
                 */
                source: function (request, response) { //MUESTRA LAS OPCIONES DEL AUTOCOMPLETE
                    /*
                     //Puesto que ahora se muestran los resultados en el menú de elementos draggables ya no es necesario la acción "select"
                     //Ésta tenía lugar cuando los resultados se mostraban en un desplegable bajo el campo de búsqueda y se seleccionaba uno de ellos
                     var buscar_almacen = 1; //Busca en todos los almaceces
                     var num_pagina = 1;
                     $.ajax({
                     url: base_url + "usuarios/gestor_inventario_usuario/listado_productos_usuario",
                     dataType: 'json',
                     type: 'POST',
                     data: {
                     'id_usuario': id_usuario,
                     'num_pagina': -1,
                     'busqueda': $("#filtro_referencias").val(),
                     'items_por_pagina': 100,
                     'buscar_almacen': buscar_almacen,
                     'tipo': 1,
                     'autocompletar': 1
                     },
                     success: function (data) {
                     //Muestra los resultados en un desplegable bajo el campo de búsqueda
                     response(data.respuesta.slice(0, 200));
                     }
                     });
                     */
                    $.ajax({
                        url: base_url + "usuarios/gestor_inventario_usuario/obtener_referencias_usuario",
                        dataType: 'json',
                        type: 'POST',
                        data: {
                            'id_usuario': id_usuario,
                            'tipo': 1,
                            'cantidades': 'si',
                            'autocompletar': $("#filtro_referencias").val()
                        },
                        success: function (data) {
                            //Muestra los resultados en el menú de elementos draggables
                            $('#listado-referencias-inventario').remove();
                            cargar_referencias_usuario('', 1, data);
                        }
                    });
                },
                selectFirst: true
            });
        }
    });

});

function borrar_bulto_inventario() {
    let numero_bultos_inventario = obtener_numero_bultos_inventario();
    let referencias_bulto = $(this).parents('.bulto-inventario').find('.bulto-inventario-dragado');

    if (numero_bultos_inventario > 1) {
        if (referencias_bulto.length > 0) {
            referencias_bulto.each(function () {
                let elemento = $(this);
                devolver_referencia_aside(elemento);
            });
        }

        $(this).parents('.bulto-inventario').remove();
        renumerar_bultos_inventario();

        if (numero_bultos_inventario == 2) {
            $('.borrar-bulto-inventario').hide();
        }


    }

    return false;
}

function obtener_numero_bultos_inventario() {
    let numero_bultos = 0;

    numero_bultos = $('.bulto-inventario').length;

    return numero_bultos;
}

function obten_cajas_usuario() {
    let cajas;

    $.ajax({
        url: base_url + '/usuarios/gestor_inventario_usuario/obtener_referencias_usuario',
        type: 'post',
        cache: false,
        data: datos,
        success: function (respuesta) {
            let html = '';
            let cajas = $.parseJSON(respuesta);

            return;
        }
    });
}

function pinta_bulto_inventario() {
    let html = '';
    let numero_bulto = $('.bulto-inventario').length + 1;

    html += '<div class="bulto-inventario" data-numero-bulto="' + numero_bulto + '">';
    html += '<div class="cabecera-bulto">';
    html += '<p>Bulto <span class="numero-bulto">' + numero_bulto + '</span><span class="editar-bulto-inventario">Editar</span><span class="borrar-bulto-inventario" style="display: none;">x</span></p>';
    html += '</div>';
    html += '<div class="cuerpo-bulto">';
    html += '<div class="form-group">';
    html += '<select class="caja-bulto-inventario form-control">';
    html += '<option value="-1">Sin caja</option>';
    html += pinta_options_cajas_usuario();
    html += '</select>';
    html += '<div class="contenedor-medidas-peso-bulto">';
    html += '<div class="medidas-bulto">';
    html += '<p><img class="icono-medidas-peso" src="' + base_url + 'design/ngg/20180419/img/usuarios/envio_pasos/icono-medida.svg"><span class="span-ancho">0</span> x <span class="span-largo">0</span> x <span class="span-alto">0</span> cm</p>';
    html += '</div>';
    html += '<div class="peso-bulto">';
    html += '<p><img class="icono-medidas-peso" src="' + base_url + 'design/ngg/20180419/img/usuarios/envio_pasos/icono-peso.svg"><span class="span-peso">0</span> Kg</p>';
    html += '</div>';
    html += '</div>';
    html += '</div>';
    html += '</div>';
    html += '<div class="pie-bulto">';
    html += '<div class="aniadir-bulto-inventario">';
    html += '<p><span>+</span> Añadir referencias</p>';
    html += '</div>';
    html += '<div class="area-dropable">';
    html += '<p class="arrastra-aqui">Arrastra aquí tus artículos</p>';
    html += '</div>';
    html += '</div>';
    html += '</div>';

    html += '<div class="nuevo-bulto-dropable">';
    html += '<p>Arrastra aquí tus artículos para crear un nuevo bulto</p>';
    html += '<div class="linea-horizontal">';
    html += '<span>o</span>';
    html += '</div>';
    html += '<div class="aniadir-bulto-inventario-drop">';
    html += '<p><span>+</span> Nuevo bulto</p>';
    html += '</div>';
    html += '</div>';

    $('.bultos-cuerpo').append(html);

    $('.bulto-inventario').last().find('.area-dropable').droppable({
        accept: '.referencia-inventario-fila, .bulto-inventario-dragado, .grupo-inventario-fila',
        hoverClass: "area-dropable-hover",
        drop: function (event, ui) {
            let elemento = ui.draggable;

            if (elemento.hasClass('referencia-inventario-fila')) {
                let cantidad = elemento.find('.referencia-cantidad').val();
                let nombre = elemento.find('.columna-nombre p').text();
                let referencia = elemento.find('.columna-referencia p').text();
                let id_referencia = elemento.data('id-referencia');
                let peso = elemento.data('peso');
                let ancho = elemento.data('ancho');
                let largo = elemento.data('largo');
                let alto = elemento.data('alto');
                let cantidad_inicial = parseInt(elemento.find('.numero-restante').text());
                let caja_drop = $(this).parents('.bulto-inventario').find('.caja-bulto-inventario').val();
                let bulto_inventario = $(this).parents('.bulto-inventario');
                let elemento_drop = $(this);
                let referencias_drop = elemento_drop.find('.bulto-inventario-dragado');

                if ((cantidad > 1 && caja_drop == -1) || (caja_drop == -1 && referencias_drop.length == 1)) {
                    cargar_modal_aviso(elemento, elemento_drop, true, false);
                    return;
                } else {
                    elemento.find('.numero-restante').text(cantidad_inicial - 1);

                    elemento_drop.find('.arrastra-aqui').hide();

                    for (let i = 0; i < cantidad; i++) {
                        $(this).append(html_referencia_dragada(nombre, referencia, cantidad, id_referencia, peso, ancho, largo, alto));
                    }

                    $('.icono-cantidad').hide();
                    elemento_drop.css('display', 'block');

                    elemento.find('.referencia-cantidad').val(1);
                    recalcular_medidas_peso_bulto(bulto_inventario);
                }
            } else if (elemento.hasClass('bulto-inventario-dragado')) {
                let replica = elemento.clone();
                let bulto_drag = elemento.parents('.bulto-inventario');
                let caja_drop = $(this).parents('.bulto-inventario').find('.caja-bulto-inventario').val();
                let elemento_drop = $(this);
                let referencias_drop = elemento_drop.find('.bulto-inventario-dragado');
                let bulto_drop = elemento_drop.parents('.bulto-inventario');

                if (caja_drop == -1 && referencias_drop.length == 1) {
                    cargar_modal_aviso(elemento, elemento_drop, true, true);
                    return;
                } else {
                    $(this).append(replica);
                    $(this).find('.arrastra-aqui').hide();
                    $(this).css('display', 'block');
                    elemento.remove();
                    $('.helper').remove();
                }

                if (bulto_drag.find('.bulto-inventario-dragado').length < 1) {
                    $('.icono-cantidad').hide();
                    bulto_drag.find('.area-dropable').css('display', 'flex');
                    bulto_drag.find('.arrastra-aqui').show();
                }

                recalcular_medidas_peso_bulto(bulto_drag);
                recalcular_medidas_peso_bulto(bulto_drop);
            } else if (elemento.hasClass('grupo-inventario-fila')) {
                let caja = elemento.data('caja');
                let referencias = elemento.data('info-referencias').replace(/\'/g, '"');
                let referencias_json = $.parseJSON(referencias);
                let elemento_drop = $(this);

                if (caja == -1 && usar_grupo_sin_caja(referencias_json)) {
                    $('#modal_grupo_sin_caja').modal('show');
                } else {
                    elemento_drop.parents('.bulto-inventario').find('.caja-bulto-inventario').val(caja);
                    elemento_drop.find('.bulto-inventario-dragado').remove();

                    referencias_json.forEach(function (referencia) {
                        let id_referencia = referencia.id;
                        let nombre = referencia.nombre;
                        let cantidad = referencia.cantidad;
                        let referencia_cliente = referencia.referencia;
                        let peso = referencia.peso;
                        let ancho = referencia.ancho;
                        let largo = referencia.largo;
                        let alto = referencia.alto;
                        let cantidad_inicial = $('[data-id-referencia="' + id_referencia + '"]').find('.numero-restante').text();

                        $('[data-id-referencia="' + id_referencia + '"]').find('.numero-restante').text(cantidad_inicial - cantidad);

                        for (let i = 0; i < cantidad; i++) {
                            elemento_drop.append(html_referencia_dragada(nombre, referencia_cliente, cantidad, id_referencia, peso, ancho, largo, alto));
                        }
                    });

                    $('.icono-cantidad').hide();
                    elemento_drop.css('display', 'block');
                    elemento_drop.find('.arrastra-aqui').hide();
                    recalcular_medidas_peso_bulto(elemento_drop.parents('.bulto-inventario'));
                }
            }

            $(".area-dropable .bulto-inventario-dragado").draggable({
                revert: 'invalid',
                containment: "document",
                cursorAt: {left: 10},
                helper: function () {
                    let elemento = $(this);
                    let cantidad = elemento.find('.referencia-cantidad').val();
                    let nombre = elemento.find('.columna-nombre p').text();
                    let referencia = elemento.find('.columna-referencia p').text();
                    let peso = elemento.data('peso');
                    let ancho = elemento.data('ancho');
                    let largo = elemento.data('largo');
                    let alto = elemento.data('alto');
                    let html = html_referencia_dragada_helper(nombre, referencia, cantidad, peso, ancho, largo, alto);

                    return html;
                },
                scroll: true,
                start: function (event, ui) {
                    let elemento = $(this);

                    elemento.addClass('referencia-seleccionada');
                }
            });

            $('.referencia-seleccionada').removeClass('referencia-seleccionada');
        }
    });

    $('.nuevo-bulto-dropable').droppable({
        accept: '.referencia-inventario-fila, .bulto-inventario-dragado, .grupo-inventario-fila',
        hoverClass: "area-dropable-hover",
        drop: function (event, ui) {
            let elemento = ui.draggable;

            if (elemento.hasClass('referencia-inventario-fila')) {
                let cantidad = elemento.find('.referencia-cantidad').val();
                let nombre = elemento.find('.columna-nombre p').text();
                let referencia = elemento.find('.columna-referencia p').text();
                let id_referencia = elemento.data('id-referencia');
                let peso = elemento.data('peso');
                let ancho = elemento.data('ancho');
                let largo = elemento.data('largo');
                let alto = elemento.data('alto');
                let cantidad_inicial = parseInt(elemento.find('.numero-restante').text());
                let elemento_drop = $(this);

                if (cantidad > 1) {
                    cargar_modal_aviso(elemento, elemento_drop, false, false);
                    return;
                } else {
                    generar_nuevo_bulto_inventario();

                    for (let i = 0; i < cantidad; i++) {
                        $('.bulto-inventario').last().find('.area-dropable').append(html_referencia_dragada(nombre, referencia, cantidad, id_referencia, peso, ancho, largo, alto));
                        elemento.find('.numero-restante').text(cantidad_inicial - 1);
                    }

                    $('.bulto-inventario').last().find('.arrastra-aqui').hide();
                    $('.icono-cantidad').hide();
                    $('.bulto-inventario').last().find('.area-dropable').css('display', 'block');
                    recalcular_medidas_peso_bulto($('.bulto-inventario').last());

                    elemento.find('.referencia-cantidad').val(1);
                }
            } else if (elemento.hasClass('bulto-inventario-dragado')) {
                let replica = elemento.clone();
                let padre = elemento.parents('.bulto-inventario');

                generar_nuevo_bulto_inventario();
                $('.bulto-inventario').last().find('.area-dropable').append(replica);
                $('.bulto-inventario').last().find('.arrastra-aqui').hide();
                $('.icono-cantidad').hide();
                $('.bulto-inventario').last().find('.area-dropable').css('display', 'block');
                elemento.remove();
                $('.helper').remove();

                if (padre.find('.bulto-inventario-dragado').length < 2) {
                    padre.find('.area-dropable').css('display', 'flex');
                    padre.find('.arrastra-aqui').show();
                }

                recalcular_medidas_peso_bulto(padre);
                recalcular_medidas_peso_bulto($('.bulto-inventario').last());
            } else if (elemento.hasClass('grupo-inventario-fila')) {
                let caja = elemento.data('caja');
                let referencias = elemento.data('info-referencias').replace(/\'/g, '"');
                let referencias_json = $.parseJSON(referencias);
                let descontar = descontar_referencias_grupo(referencias_json);
                if (descontar) {
                    if (caja == -1) {
                        referencias_json.forEach(function (referencia) {
                            let id_referencia = referencia.id;
                            let nombre = referencia.nombre;
                            let cantidad = referencia.cantidad;
                            let referencia_cliente = referencia.referencia;
                            let peso = referencia.peso;
                            let ancho = referencia.ancho;
                            let largo = referencia.largo;
                            let alto = referencia.alto;

                            for (let i = 0; i < cantidad; i++) {
                                let cantidad_por_usar = $('#listado-referencias-inventario [data-id-referencia="' + referencia.id + '"]').find('.numero-restante').text();
                                generar_nuevo_bulto_inventario();
                                $('.bulto-inventario').last().find('.area-dropable').append(html_referencia_dragada(nombre, referencia_cliente, cantidad, id_referencia, peso, ancho, largo, alto));
                                $('.bulto-inventario').last().find('.area-dropable').css('display', 'block');
                                $('.bulto-inventario').last().find('.area-dropable').find('.arrastra-aqui').hide();
                                $('#listado-referencias-inventario [data-id-referencia="' + referencia.id + '"]').find('.numero-restante').text(cantidad_por_usar - 1);
                            }
                        });

                        $('.icono-cantidad').hide();
                    } else {
                        generar_nuevo_bulto_inventario();
                        let elemento_drop = $('.bulto-inventario').last().find('.area-dropable');

                        elemento_drop.parents('.bulto-inventario').find('.caja-bulto-inventario').val(caja);

                        referencias_json.forEach(function (referencia) {
                            let id_referencia = referencia.id;
                            let nombre = referencia.nombre;
                            let cantidad = referencia.cantidad;
                            let referencia_cliente = referencia.referencia;
                            let peso = referencia.peso;
                            let ancho = referencia.ancho;
                            let largo = referencia.largo;
                            let alto = referencia.alto;

                            for (let i = 0; i < cantidad; i++) {
                                let cantidad_por_usar = $('#listado-referencias-inventario [data-id-referencia="' + referencia.id + '"]').find('.numero-restante').text();
                                $('#listado-referencias-inventario [data-id-referencia="' + referencia.id + '"]').find('.numero-restante').text(cantidad_por_usar - 1);
                                elemento_drop.append(html_referencia_dragada(nombre, referencia_cliente, cantidad, id_referencia, peso, ancho, largo, alto));
                            }
                        });

                        $('.icono-cantidad').hide();
                        elemento_drop.css('display', 'block');
                        elemento_drop.find('.arrastra-aqui').hide();
                        recalcular_medidas_peso_bulto($('.bulto-inventario').last());
                    }
                } else {
                    $('#modal_cantidad_insuficiente').modal('show');
                }
            }

            $(".area-dropable .bulto-inventario-dragado").draggable({
                revert: 'invalid',
                containment: "document",
                cursorAt: {left: 10},
                helper: function () {
                    let elemento = $(this);
                    let cantidad = elemento.find('.referencia-cantidad').val();
                    let nombre = elemento.find('.columna-nombre p').text();
                    let referencia = elemento.find('.columna-referencia p').text();
                    let peso = elemento.data('peso');
                    let ancho = elemento.data('ancho');
                    let largo = elemento.data('largo');
                    let alto = elemento.data('alto');
                    let html = html_referencia_dragada_helper(nombre, referencia, cantidad, peso, ancho, largo, alto);

                    return html;
                },
                start: function (event, ui) {
                    let elemento = $(this);

                    elemento.addClass('referencia-seleccionada');
                },
                stop: function (event, ui) {
                    let elemento = $(this);

                    elemento.removeClass('referencia-seleccionada');
                }
            });

            $('.referencia-seleccionada').removeClass('referencia-seleccionada');
        }
    });
}

function recalcular_medidas_peso_bulto(bulto_inventario) {
    let caja = bulto_inventario.find('.caja-bulto-inventario option:selected');
    let referencias = bulto_inventario.find('.bulto-inventario-dragado');
    let peso = 0;
    let alto = 0;
    let ancho = 0;
    let largo = 0;

    if (caja.val() == -1) {
        alto = referencias.first().data('alto');
        ancho = referencias.first().data('ancho');
        largo = referencias.first().data('largo');
    } else if (caja.val() > 0) {
        alto = caja.data('caja-alto');
        ancho = caja.data('caja-ancho');
        largo = caja.data('caja-largo');
    }

    referencias.each(function () {
        peso += parseFloat($(this).data('peso'));
    });

    if (referencias.length > 0) {
        bulto_inventario.find('.contenedor-medidas-peso-bulto').css('display', 'flex');
        bulto_inventario.find('.span-peso').text(peso.toFixed(2));
        bulto_inventario.find('.span-alto').text(alto);
        bulto_inventario.find('.span-ancho').text(ancho);
        bulto_inventario.find('.span-largo').text(largo);
    } else {
        bulto_inventario.find('.contenedor-medidas-peso-bulto').hide();
    }
}

function usar_grupo_sin_caja(referencias) {
    if (referencias.length > 1) {
        return false;
    } else {
        referencias.forEach(function (referencia) {
            if (referencia.cantidad_grupo > 1) {
                return false;
            }
        });
    }

    return true;
}

function descontar_referencias_grupo(referencias) {
    let descontar = true;

    referencias.forEach(function (referencia) {
        let elemento_referencia = $('#listado-referencias-inventario [data-id-referencia="' + referencia.id + '"]');
        let cantidad_almacen = elemento_referencia.find('.numero-restante').text();
        let cantidad_grupo = referencia.cantidad;
        let cantidad_final = cantidad_almacen - cantidad_grupo;

        if (cantidad_final < 0) {
            descontar = false;
        }
    });

    return descontar;
}

function cargar_modal_aviso(elemento_drag, elemento_drop, solo_caja, clonar) {
    let cantidad = elemento_drag.find('.referencia-cantidad').val();
    let nombre = elemento_drag.find('.columna-nombre p').text();
    let referencia = elemento_drag.find('.columna-referencia p').text();
    let id_referencia = elemento_drag.data('id-referencia');
    let peso = elemento_drag.data('peso');
    let ancho = elemento_drag.data('ancho');
    let largo = elemento_drag.data('largo');
    let alto = elemento_drag.data('alto');
    let cantidad_inicial = parseInt(elemento_drag.find('.numero-restante').text());
    let bulto_drop = elemento_drop.parents('.bulto-inventario');
    let bulto_drag = elemento_drag.parents('.bulto-inventario');

    $('#cajas-modal').off();
    $('.boton-bulto-por-articulo').off();

    $('#cajas-modal').change(function () {
        let caja_elegida = $(this).val();

        $('#modal_multireferencia_sin_caja').modal('hide');

        if (elemento_drop.hasClass('area-dropable')) {
            if (elemento_drag.hasClass('bulto-inventario-dragado')) {
                elemento_drop.parents('.bulto-inventario').find('.caja-bulto-inventario').val(caja_elegida);
                $(this).val(-1);
                elemento_drop.append(elemento_drag);
                $('.helper').remove();

                if (bulto_drag.find('.bulto-inventario-dragado').length === 0) {
                    bulto_drag.find('.area-dropable').css('display', 'flex');
                    bulto_drag.find('.arrastra-aqui').show();
                }

                recalcular_medidas_peso_bulto(bulto_drop);
                recalcular_medidas_peso_bulto(bulto_drag);
            } else {
                if (cantidad_inicial >= 0) {
                    elemento_drop.parents('.bulto-inventario').find('.caja-bulto-inventario').val(caja_elegida);
                    $(this).val(-1);

                    if (clonar) {
                        elemento_drop.append(elemento_drag);

                    } else {
                        elemento_drag.find('.numero-restante').text(cantidad_inicial);
                        elemento_drop.find('.arrastra-aqui').hide();

                        for (let i = 0; i < cantidad; i++) {
                            elemento_drop.append(html_referencia_dragada(nombre, referencia, cantidad, id_referencia, peso, ancho, largo, alto));
                        }

                        $('.icono-cantidad').hide();
                        elemento_drop.css('display', 'block');

                        elemento_drag.find('.referencia-cantidad').val(1);
                        recalcular_medidas_peso_bulto(bulto_drop);
                    }
                } else {
                    $('#modal_cantidad_insuficiente').modal('show');
                }
            }
        } else if (elemento_drop.hasClass('nuevo-bulto-dropable')) {
            if (cantidad_inicial >= 0) {
                generar_nuevo_bulto_inventario();
                $('.bulto-inventario').last().find('.caja-bulto-inventario').val(caja_elegida);
                $(this).val(-1);

                elemento_drag.find('.numero-restante').text(cantidad_inicial);
                $('.bulto-inventario').last().find('.arrastra-aqui').hide();

                for (let i = 0; i < cantidad; i++) {
                    $('.bulto-inventario').last().find('.area-dropable').append(html_referencia_dragada(nombre, referencia, cantidad, id_referencia, peso, ancho, largo, alto));
                    recalcular_medidas_peso_bulto($('.bulto-inventario').last());
                }

                $('.icono-cantidad').hide();
                $('.bulto-inventario').last().find('.area-dropable').css('display', 'block');

                elemento_drag.find('.referencia-cantidad').val(1);
            } else {
                $('#modal_cantidad_insuficiente').modal('show');
            }
        }

        $(".area-dropable .bulto-inventario-dragado").draggable({
            revert: 'invalid',
            containment: "document",
            cursorAt: {left: 10},
            helper: function () {
                let elemento = $(this);
                let cantidad = elemento.find('.referencia-cantidad').val();
                let nombre = elemento.find('.columna-nombre p').text();
                let referencia = elemento.find('.columna-referencia p').text();
                let peso = elemento.data('peso');
                let ancho = elemento.data('ancho');
                let largo = elemento.data('largo');
                let alto = elemento.data('alto');
                let html = html_referencia_dragada_helper(nombre, referencia, cantidad, peso, ancho, largo, alto);

                return html;
            },
            scroll: true,
            start: function (event, ui) {
                let elemento = $(this);

                elemento.addClass('referencia-seleccionada');
            },
            stop: function (event, ui) {
                let elemento = $(this);

                elemento.removeClass('referencia-seleccionada');
            }
        });
    });

    $('.boton-bulto-por-articulo').click(function () {
        $('#modal_multireferencia_sin_caja').modal('hide');

        elemento_drag.find('.numero-restante').text(cantidad_inicial);
        elemento_drag.find('.referencia-cantidad').val(1);

        for (let i = 0; i < cantidad; i++) {
            generar_nuevo_bulto_inventario();

            let bulto = $('.bulto-inventario').last();
            bulto.find('.area-dropable').append(html_referencia_dragada(nombre, referencia, cantidad, id_referencia, peso, ancho, largo, alto));
            bulto.find('.area-dropable').css('display', 'block');
            bulto.find('.arrastra-aqui').hide();
            $('.icono-cantidad').hide();
            recalcular_medidas_peso_bulto(bulto);
        }

        $(".area-dropable .bulto-inventario-dragado").draggable({
            revert: 'invalid',
            containment: "document",
            cursorAt: {left: 10},
            helper: function () {
                let elemento = $(this);
                let cantidad = elemento.find('.referencia-cantidad').val();
                let nombre = elemento.find('.columna-nombre p').text();
                let referencia = elemento.find('.columna-referencia p').text();
                let peso = elemento.data('peso');
                let ancho = elemento.data('ancho');
                let largo = elemento.data('largo');
                let alto = elemento.data('alto');
                let html = html_referencia_dragada_helper(nombre, referencia, cantidad, peso, ancho, largo, alto);

                return html;
            },
            scroll: true,
            start: function (event, ui) {
                let elemento = $(this);

                elemento.addClass('referencia-seleccionada');
            },
            stop: function (event, ui) {
                let elemento = $(this);

                elemento.removeClass('referencia-seleccionada');
            }
        });
    });

    if (solo_caja) {
        $('.centrar').hide();
        $('.boton-bulto-por-articulo').hide();
    } else {
        $('.centrar').show();
        $('.boton-bulto-por-articulo').show();
    }

    $('#modal_multireferencia_sin_caja').modal('show');
}

function generar_nuevo_bulto_inventario() {
    $('.nuevo-bulto-dropable').remove();
    pinta_bulto_inventario();
    $('.nuevo-bulto-dropable').css('display', 'flex');

    $('.bulto-inventario').last().find('.aniadir-bulto-inventario').hide();
    $('.bulto-inventario').last().find('.area-dropable').css('display', 'flex');
    $('.bulto-inventario').last().find('.editar-bulto-inventario').show();
    $('.bulto-inventario').find('.borrar-bulto-inventario').show();
}

function renumerar_bultos_inventario() {
    let bultos_inventario = $('.bulto-inventario');
    let numero = 1;

    bultos_inventario.each(function () {
        $(this).attr('data-numero-bulto', numero);
        $(this).find('.numero-bulto').text(numero);
        numero++;
    });

    return false;
}

function desplegar_aside(evento) {
    switch (evento.data.tipo) {
        case 'bulto-inventario':
            $('#aside-buscador').removeClass('direcciones origen destino bultos-predefinidos');
            $('#aside-buscador-cabecera h2').html('Logística');
            $('.editar-bulto-inventario').show();

            if ($('.bultos-inventario').length < 1) {
                if ($('#aside-buscador').is(':visible')) {
                    $('#aside-buscador').toggle('slide');
                }

                $('.cuerpo #contenedor').html('');
                $('#aside-buscador-cuerpo .cabecera').html('<p id="muestra-referencias" class="seleccionado">Referencias</p><p id="muestra-grupos">Grupos</p>');
                $('#aside-buscador-cuerpo .filtro_referencias').html('<input type="text" id="filtro_referencias" class="form-control ui-autocomplete-input" placeholder="Escribe el nombre o la referencia que quieras buscar">');
                $('#aside-buscador').addClass('bultos-inventario');
                cargar_referencias_usuario();
                cargar_grupos_usuario();
                mostrar_referencias();
            }

            if ($('#aside-buscador').not(':visible')) {
                $('.aniadir-bulto-inventario').hide();
                $('#filtro_referencias').val('');
                $('.area-dropable').css('display', 'flex');
                $('.nuevo-bulto-dropable').css('display', 'flex');
            }

            $('#aside-buscador').toggle('slide');

            break;
    }
}

function cargar_referencias_usuario(id_seleccionada = '', filtro_referencias = '', resultados = '') {
    let referencias_inventario;
    let id = id_seleccionada;
    let datos = {
        'tipo': 1,
        'cantidades': 'si',
        'id': id
    };

    $.ajax({
        url: base_url + '/usuarios/gestor_inventario_usuario/obtener_referencias_usuario',
        type: 'post',
        cache: false,
        data: datos,
        success: function (respuesta) {
            if (filtro_referencias == 1) {
                referencias_inventario = resultados;
            } else {
                referencias_inventario = $.parseJSON(respuesta);
            }
            $('.cuerpo #contenedor').append('<div id="listado-referencias-inventario"></div>');
            referencias_inventario.forEach(function (referencia_inventario) {
                if (referencia_inventario.cantidad_disponible > 0) {
                    let html_referencia_inventario = generar_html_referencia_inventario(referencia_inventario);
                    $('.cuerpo #listado-referencias-inventario').append(html_referencia_inventario);
                }
            });

            $(".referencia-inventario-fila").draggable({
                revert: 'invalid',
                containment: "document",
                cursorAt: {left: 10},
                helper: function () {
                    let elemento = $(this);
                    let cantidad = elemento.find('.referencia-cantidad').val();
                    let nombre = elemento.find('.columna-nombre p').text();
                    let referencia = elemento.find('.columna-referencia p').text();
                    let peso = elemento.data('peso');
                    let ancho = elemento.data('ancho');
                    let largo = elemento.data('largo');
                    let alto = elemento.data('alto');
                    let html = html_referencia_dragada(nombre, referencia, cantidad, peso, ancho, largo, alto);

                    return html;
                },
                start: function (event, ui) {
                    let elemento = $(this);
                    let seleccionados = parseInt(elemento.find('.referencia-cantidad').val());
                    let cantidad_inicial = parseInt(elemento.find('.numero-restante').text());
                    let total = cantidad_inicial - seleccionados;

                    if (total < 0) {
                        $('#modal_cantidad_insuficiente').modal('show');
                        $('.area-dropable').droppable("disable");
                        $('.nuevo-bulto-dropable').droppable("disable");
                    } else {
                        $('.area-dropable').droppable("enable");
                        $('.nuevo-bulto-dropable').droppable("enable");
                    }

                    elemento.find('.numero-restante').text(total);
                    elemento.addClass('referencia-seleccionada');
                    $('#buscador').css('z-index', '1');
                },
                stop: function (event, ui) {
                    let elemento = $(this);
                    let cantidad_inicial = parseInt(elemento.find('.numero-restante').text());
                    let seleccionados = parseInt(elemento.find('.referencia-cantidad').val());
                    let total = cantidad_inicial + seleccionados;

                    elemento.find('.numero-restante').text(total);
                    elemento.removeClass('referencia-seleccionada');
                    $('#buscador').css('z-index', '2');
                }
            });

            $('#aside-buscador-cuerpo .cuerpo').droppable({
                accept: '.area-dropable .bulto-inventario-dragado',
                drop: function (event, ui) {
                    let elemento = ui.draggable;
                    let bulto_drag = elemento.parents('.bulto-inventario');
                    devolver_referencia_aside(elemento);
                    recalcular_medidas_peso_bulto(bulto_drag);

                    $('.referencia-seleccionada').removeClass('referencia-seleccionada');
                }
            });

        }
    });
}

function cargar_grupos_usuario() {
    let referencias_inventario;
    let grupos_inventario;

    let datos = {
        'grupos': 'si'
    };

    $.ajax({
        url: base_url + '/usuarios/gestor_inventario_usuario/obtener_referencias_usuario',
        type: 'post',
        cache: false,
        data: datos,
        success: function (respuesta) {
            grupos_inventario = $.parseJSON(respuesta);

            $('.cuerpo #contenedor').append('<div id="listado-grupos-inventario" style></div>');

            grupos_inventario.forEach(function (grupo_inventario) {
                let html_grupo_inventario = generar_html_grupo_inventario(grupo_inventario);
                $('.cuerpo #listado-grupos-inventario').append(html_grupo_inventario);
            });

            $(".grupo-inventario-fila").draggable({
                revert: 'invalid',
                containment: "document",
                cursorAt: {left: 10},
                helper: function () {
                    let elemento = $(this);
                    let nombre = elemento.data('nombre');
                    let numero_elementos = elemento.data('numero-elementos');
                    let id_grupo = elemento.data('id-grupo');
                    let html = html_grupo_dragado(nombre, numero_elementos, id_grupo);

                    return html;
                },
                start: function (event, ui) {
                    let elemento = $(this);
                    let referencias = elemento.data('info-referencias').replace(/\'/g, '"');
                    let referencias_json = $.parseJSON(referencias);
                    let descontar = descontar_referencias_grupo(referencias_json);

                    if (!descontar) {
                        $('#modal_cantidad_insuficiente').modal('show');
                        $('.area-dropable').droppable('disable');
                        $('.nuevo-bulto-dropable').droppable('disable');
                    } else {
                        $('.area-dropable').droppable('enable');
                        $('.nuevo-bulto-dropable').droppable('enable');
                    }

                    elemento.addClass('referencia-seleccionada');
                    $('#buscador').css('z-index', '1');
                },
                stop: function (event, ui) {
                    let elemento = $(this);

                    elemento.removeClass('referencia-seleccionada');
                    $('#buscador').css('z-index', '2');
                }
            });
        }
    });
}

function devolver_referencia_aside(elemento) {
    let id_referencia = elemento.data('id-referencia');
    let restantes = parseInt($('[data-id-referencia="' + id_referencia + '"]').find('.numero-restante').text());
    let padre = elemento.parents('.bulto-inventario');

    $('[data-id-referencia="' + id_referencia + '"]').find('.numero-restante').text(restantes + 1);
    elemento.remove();
    $('.helper').remove();

    if (padre.find('.area-dropable .bulto-inventario-dragado').length < 1) {
        padre.find('.arrastra-aqui').show();
        padre.find('.area-dropable').css('display', 'flex');
    }
}

function cerrar_aside() {
    $('#aside-buscador').toggle('slide');
    $('#listado-referencias-inventario').html('');
    cargar_referencias_usuario();
}

function generar_html_bulto_predefinido(bulto_predefinido) {
    let html = '';

    html += '<div class="bulto-predefinido-tarjeta" data-peso="' + bulto_predefinido.peso + '" data-alto="' + bulto_predefinido.alto + '" data-ancho="' + bulto_predefinido.ancho + '" data-largo="' + bulto_predefinido.largo + '" data-numero-bulto="0">';
    html += '<div class="cabecera-bulto-predefinido-tarjeta">';
    html += '<p>' + bulto_predefinido.nombre + '<span class="icono-desplegar">></span></p>';
    html += '<p>' + '' + '</p>';
    html += '</div>';
    html += '<div class="cuerpo-bulto-predefinido-tarjeta">';
    html += '<hr>';
    html += '<div class="columna-completa">';
    html += '<p>' + bulto_predefinido.peso + 'kg ' + bulto_predefinido.alto + ' x ' + bulto_predefinido.ancho + ' x ' + bulto_predefinido.largo + '</p>';
    html += '</div>';
    html += '</div>';
    html += '</div>';

    return html;
}

function generar_html_referencia_inventario(referencia_inventario) {
    let html = '';

    html += '<div class="referencia-inventario-fila" data-id-referencia="' + referencia_inventario.id + '" data-peso="' + referencia_inventario.peso + '" data-alto="' + referencia_inventario.alto + '" data-ancho="' + referencia_inventario.ancho + '" data-largo="' + referencia_inventario.largo + '" data-numero-bulto="0" data-cantidad="' + referencia_inventario.cantidad + '">';
    html += '<div class="columna-nombre">';
    html += '<p><img src="' + base_url + 'design/ngg/20180419/img/usuarios/envio_pasos/icono-dragable.svg">' + referencia_inventario.nombre + '</p>';
    html += '</div>';
    html += '<div class="columna-referencia">';
    html += '<p>' + referencia_inventario.referencia_cliente + '</p>';
    html += '</div>';
    html += '<div class="columna-en-almacen">';
    html += '<p><span class="numero-restante">' + referencia_inventario.cantidad_disponible + '</span> restantes</p>';
    html += '</div>';
    html += '<div class="columna-cantidad">';
    html += '<p>';
    html += '<span class="control-cantidad resta">-</span>';
    html += '<input type="number" class="referencia-cantidad" min="1" max="99" value="1">';
    html += '<span class="control-cantidad suma">+</span>';
    html += '</p>';
    html += '</div>';
    html += '</div>';

    return html;
}

function generar_html_grupo_inventario(grupo_inventario) {
    let html = '';
    let html_referencias = '';
    let json_referencias_grupo = new Array();
    let id_caja = -1;

    if (typeof grupo_inventario.caja !== 'undefined') {
        id_caja = grupo_inventario.caja.id;
    }

    grupo_inventario.referencias.forEach(function (referencia) {
        let objeto = {
            'id': referencia.id,
            'cantidad': referencia.cantidad_grupo,
            'nombre': referencia.nombre,
            'referencia': referencia.referencia_cliente,
            'peso': referencia.peso,
            'alto': referencia.alto,
            'largo': referencia.largo,
            'ancho': referencia.ancho
        };

        json_referencias_grupo.push(objeto);

        html_referencias += '<p>' + referencia.cantidad_grupo + ' x ' + referencia.nombre + ' | Ref: ' + referencia.referencia_cliente + '</p>';
    });

    html += '<div class="grupo-inventario-fila" data-nombre="' + grupo_inventario.nombre + '" data-numero-elementos="' + grupo_inventario.referencias.length + '" data-id-grupo="' + grupo_inventario.id + '" data-info-referencias="' + JSON.stringify(json_referencias_grupo).replace(/"/g, "'") + '" data-caja="' + id_caja + '">';
    html += '<div class="cabecera-grupo-tarjeta">';
    html += '<div class="columna-nombre">';
    html += '<p><img src="' + base_url + 'design/ngg/20180419/img/usuarios/envio_pasos/icono-dragable.svg">' + grupo_inventario.nombre + '</p>';
    html += '</div>';
    html += '<div class="columna-elementos">';
    html += '<p>' + grupo_inventario.referencias.length + ' referencias <span class="icono-desplegar">></span></p>';
    html += '</div>';
    html += '</div>';
    html += '<div class="cuerpo-grupo-tarjeta">';
    html += '<hr>';
    html += html_referencias;
    html += '</div>';
    html += '</div>';

    return html;
}

function mostrar_info_grupo_referencias() {
    let icono = $(this);
    let elemento = $(this).parents('.cabecera-grupo-tarjeta').next();

    if (elemento.is(':visible')) {
        elemento.slideUp();
        icono.css({transform: 'rotate(90deg)'});
    } else {
        elemento.slideDown();
        icono.css({transform: 'rotate(270deg)'});
    }
}

function construir_datos_bultos_inventario() {
    let bultos_inventario = $('.bulto-inventario');
    let datos_bultos_inventario = new Array();

    bultos_inventario.each(function () {
        let referencias = $(this).find('.bulto-inventario-dragado');
        let datos_referencias = {};

        referencias.each(function () {
            let id_referencia = $(this).data('id-referencia');

            if (id_referencia in datos_referencias) {
                datos_referencias[id_referencia]++;
            } else {
                datos_referencias[id_referencia] = 1;
            }
        });

        let bulto_inventario = {
            id_caja: $(this).find('.caja-bulto-inventario').val(),
            referencias: datos_referencias
        };

        datos_bultos_inventario.push(bulto_inventario);
    });

    return datos_bultos_inventario;
}

function restar() {
    let elemento = $(this).parent().find('.referencia-cantidad');
    let valor = elemento.val();

    if (valor > 1) {
        valor--;
    }

    elemento.val(valor);
}

function sumar() {
    let elemento = $(this).parent().find('.referencia-cantidad');
    let valor = elemento.val();

    if (valor < 999) {
        valor++;
    }

    elemento.val(valor);
}

function html_referencia_dragada(nombre, referencia, cantidad, id_referencia, peso, ancho, largo, alto) {
    let html = '';

    html += '<div class="bulto-inventario-dragado" data-id-referencia="' + id_referencia + '" data-peso="' + peso + '" data-ancho="' + ancho + '" data-largo="' + largo + '" data-alto="' + alto + '">';
    html += '<div class="columna-nombre">';
    html += '<p><img src="' + base_url + 'design/ngg/20180419/img/usuarios/envio_pasos/icono-dragable.svg">' + nombre + '</p>';
    html += '</div>';
    html += '<div class="columna-referencia">';
    html += '<p>' + referencia + '</p>';
    html += '</div>';
    if (cantidad > 1) {
        html += '<span class="icono-cantidad">' + cantidad + '</span>';
    }
    html += '</div>';

    return html;
}

function html_referencia_dragada_helper(nombre, referencia, cantidad, id_referencia, peso, ancho, largo, alto) {
    let html = '';

    html += '<div class="bulto-inventario-dragado helper" data-id-referencia="' + id_referencia + '" data-peso="' + peso + '" data-ancho="' + ancho + '" data-largo="' + largo + '" data-alto="' + alto + '">';
    html += '<div class="columna-nombre">';
    html += '<p><img src="' + base_url + 'design/ngg/20180419/img/usuarios/envio_pasos/icono-dragable.svg">' + nombre + '</p>';
    html += '</div>';
    html += '<div class="columna-referencia">';
    html += '<p>' + referencia + '</p>';
    html += '</div>';
    if (cantidad > 1) {
        html += '<span class="icono-cantidad">' + cantidad + '</span>';
    }
    html += '</div>';

    return html;
}

function html_grupo_dragado(nombre, numero_elementos, id_grupo) {
    let html = '';

    html += '<div class="bulto-inventario-dragado" data-id-grupo="' + id_grupo + '">';
    html += '<div class="columna-nombre">';
    html += '<p><img src="' + base_url + 'design/ngg/20180419/img/usuarios/envio_pasos/icono-dragable.svg">' + nombre + '</p>';
    html += '</div>';
    html += '<div class="columna-elementos">';
    html += '<p>' + numero_elementos + ' referencias</p>';
    html += '</div>';
    html += '</div>';

    return html;
}

function pinta_options_cajas_usuario() {
    let html = '';
    let cajas_json = $('#cajas_usuario').text();
    console.log(cajas_json);
    let cajas = $.parseJSON(cajas_json);

    cajas.forEach(function (caja) {
        html += '<option value="' + caja.id + '" data-caja-largo="' + caja.largo + '" data-caja-ancho="' + caja.ancho + '" data-caja-alto="' + caja.alto + '">' + caja.nombre + '</option>';
    });

    return html;

}

function quitar_caja_bulto_inventario() {
    let caja_seleccionada = $(this).val();
    let bulto_inventario = $(this).parents('.bulto-inventario');
    let referencias_bulto_inventario = bulto_inventario.find('.bulto-inventario-dragado');
    let valor_previo = $(this).data('valor-previo');

    if (referencias_bulto_inventario.length > 1 && caja_seleccionada == -1) {
        $(this).val(valor_previo);
        $('#modal_quitar_caja').modal('show');

        $('.boton-quitar-caja').off();

        $('.boton-quitar-caja').click(function () {
            $('#modal_quitar_caja').modal('hide');

            referencias_bulto_inventario.each(function () {
                generar_nuevo_bulto_inventario();
                $('.bulto-inventario').last().find('.area-dropable').append($(this));
                $('.bulto-inventario').last().find('.area-dropable').css('display', 'block');
                $('.bulto-inventario').last().find('.arrastra-aqui').hide();
                recalcular_medidas_peso_bulto($('.bulto-inventario').last());
                $('.icono-cantidad').hide();
            });

            bulto_inventario.remove();
            $('.helper').remove();
            renumerar_bultos_inventario();

            $(".area-dropable .bulto-inventario-dragado").draggable({
                revert: 'invalid',
                containment: "document",
                cursorAt: {left: 10},
                helper: function () {
                    let elemento = $(this);
                    let cantidad = elemento.find('.referencia-cantidad').val();
                    let nombre = elemento.find('.columna-nombre p').text();
                    let referencia = elemento.find('.columna-referencia p').text();
                    let peso = elemento.data('peso');
                    let ancho = elemento.data('ancho');
                    let largo = elemento.data('largo');
                    let alto = elemento.data('alto');
                    let html = html_referencia_dragada_helper(nombre, referencia, cantidad, peso, ancho, largo, alto);

                    return html;
                },
                scroll: true,
                start: function (event, ui) {
                    let elemento = $(this);

                    elemento.addClass('referencia-seleccionada');
                },
                stop: function (event, ui) {
                    let elemento = $(this);

                    elemento.removeClass('referencia-seleccionada');
                }
            });
        });
    }

    recalcular_medidas_peso_bulto(bulto_inventario);
}

function almacenar_valor_previo() {
    let valor_previo = $(this).val();
    $(this).data('valor-previo', valor_previo);

    return false;
}

function mostrar_referencias() {
    $('#listado-referencias-inventario').show();
    $('#listado-grupos-inventario').hide();
    $('.filtro_referencias').css('visibility', 'visible');
    $('#aside-buscador-cuerpo .cabecera p').removeClass('seleccionado');
    $('#aside-buscador-cuerpo #muestra-referencias').addClass('seleccionado');
}

function mostrar_grupos() {
    $('#listado-referencias-inventario').hide();
    $('#listado-grupos-inventario').show();
    $('.filtro_referencias').css('visibility', 'hidden');
    $('#aside-buscador-cuerpo .cabecera p').removeClass('seleccionado');
    $('#aside-buscador-cuerpo #muestra-grupos').addClass('seleccionado');
}

function generar_bultos_referencias_cantidades_prestashop () {
    let json_referencias_cantidades = construir_datos_bultos_inventario();
    let array_bultos = obtener_peso_medidas_bultos ();
}

function obtener_peso_medidas_bultos () {
    let bultos = $('.bulto-inventario');
    let array_bultos = new Array();
    
    bultos.each(function () {
        let bulto = $(this);
        let numero_bulto = bulto.data('numero-bulto');
        let alto = bulto.find('.span-alto').text();
        let ancho = bulto.find('.span-ancho').text();
        let largo = bulto.find('.span-largo').text();
        let peso = bulto.find('.span-peso').text();
        
        array_bultos[numero_bulto] = {
            'bulto': numero_bulto,
            'peso': peso,
            'alto': alto,
            'largo': largo,
            'ancho': ancho
        };
    });
    
    return array_bultos;
}

function obtener_cajas_usuario () {
    $.ajax({
        url: base_url + '/usuarios/envio_pasos/obtener_cajas_usuario_ajax',
        type: 'post',
        cache: false,
        success: function (respuesta) {
            pinta_bulto_inventario();
            $('#cajas_usuario').text(respuesta);
            let html = rellena_bulto_inicial_select_cajas ();
            $('.caja-bulto-inventario').first().html(html);
            $('#cajas-modal').html(html);
        }
    });
}

function rellena_bulto_inicial_select_cajas () {
    let cajas_string_json = $('#cajas_usuario').text();
    let cajas = $.parseJSON(cajas_string_json);
    let html = '';
    
    cajas.forEach(function (caja) {
        html += '<option value="-1">Selecciona una caja</option>';
        html += '<option value="' + caja.id + '">' + caja.nombre + '</option>';
    });
    
    return html;
}
