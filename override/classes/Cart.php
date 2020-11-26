<?php
/**
 * 2016 Genei Gestión Logística
 *
 * GENEI S.L.
 *
 * NOTICE OF LICENSE
 *
 *  @author    Carlos Tornadijo Genei S.L.
 *  @copyright 2016 Genei S.L.
 *  @license   Commercial
 *  @version 2.0.0
 */
class Cart extends CartCore
{
    /*
    * module: genei
    * date: 2020-10-21 15:59:48
    * version: 3.1.7
    */
    public function getPackageShippingCost(
        $id_carrier = null,
        $use_tax = true,
        Country $default_country = null,
        $product_list = null,
        $id_zone = null
    ) {
        $fichero = _PS_MODULE_DIR_ . '/logcart.html';
        if (file_exists($fichero)) {
            file_put_contents(
                $fichero,
                date('Y-m-d h:i:s').': Accediendo a la función getPackageShippingCost',
                FILE_APPEND | LOCK_EX
            );
        }
        if (Module::getInstanceByName('genei')->
            configurationGet('estado_autenticacion_genei') != 1
            || Module::getInstanceByName('genei')->
            configurationGet('direccion_predeterminada_genei') == null) {
            return false;
        }
        if (!Module::getInstanceByName('genei')->isGeneiCarrier($id_carrier)) {
            return parent::getPackageShippingCost($id_carrier, $use_tax, $default_country, $product_list, $id_zone);
        } else {
            if (Dispatcher::getInstance()->getController() == 'cart') {
                return false;
            }
        }
        $id_cart = $this->id;
        if ($id_cart > 0 && Configuration::get('PS_DISABLE_OVERRIDES') != 1
            && Configuration::get('PS_DISABLE_NON_NATIVE_MODULE') != 1) {
            if (file_exists($fichero)) {
                file_put_contents(
                    $fichero,
                    date('Y-m-d h:i:s').': Obteniendo arrayprices',
                    FILE_APPEND | LOCK_EX
                );
            }
            $arrayPrices_json = utf8_encode(
                Module::getInstanceByName('genei')->cartPriceGenei($id_cart)
            );
            $arrayPrices_json =
                preg_replace("/(\n[\t ]*)([^\t ]+):/", "$1\"$2\":", $arrayPrices_json);
        }
        if (file_exists($fichero)) {
            file_put_contents(
                $fichero,
                date('Y-m-d h:i:s').': Arraypricesobtenido '.Tools::strlen($arrayPrices_json),
                FILE_APPEND | LOCK_EX
            );
        }
        if (Tools::strlen($arrayPrices_json)<20) {
            return false;
        }
        if (empty($arrayPrices_json)) {
            return 0;
        }
        $arrayPrices = Tools::jsonDecode($arrayPrices_json, true);
        foreach (array_keys($arrayPrices) as $id_genei_carrier) {
            if (file_exists($fichero)) {
                file_put_contents(
                    $fichero,
                    date('Y-m-d h:i:s').': iteración ags '.$id_genei_carrier,
                    FILE_APPEND | LOCK_EX
                );
            }
            if ((float)$arrayPrices[$id_genei_carrier]['importe']<=2) {
                continue;
            }
            if (!$use_tax) {
                $arrayPrices[$id_genei_carrier]['importe'] =
                    round(($arrayPrices[$id_genei_carrier]['importe'] / 1.21), 2);
            }
            if (Module::getInstanceByName('genei')->getCarrierVariationType($id_genei_carrier) == 0) {
                $arrayPrices[$id_genei_carrier]['importe']+=
                    Module::getInstanceByName('genei')->getCarrierVariationPriceAmount($id_genei_carrier);
            } else {
                if (Module::getInstanceByName('genei')->getCarrierVariationPriceAmount($id_genei_carrier) >= 0) {
                    $arrayPrices[$id_genei_carrier]['importe']*=
                        (1 + (Module::getInstanceByName('genei')->
                            getCarrierVariationPriceAmount($id_genei_carrier) / 100));
                } else {
                    $arrayPrices[$id_genei_carrier]['importe']/=
                        (1 + abs(Module::getInstanceByName('genei')->
                            getCarrierVariationPriceAmount($id_genei_carrier) / 100));
                }
            }
        }
        if (file_exists($fichero)) {
            file_put_contents(
                $fichero,
                date('Y-m-d h:i:s').': iteración ags fin idgc',
                FILE_APPEND | LOCK_EX
            );
        }
        $id_genei_carrier = Module::getInstanceByName('genei')->obtainGeneiCarrier($id_carrier);
        if (file_exists($fichero)) {
            file_put_contents(
                $fichero,
                date('Y-m-d h:i:s').': idgenei carrier es '.$id_genei_carrier,
                FILE_APPEND | LOCK_EX
            );
        }
        if (array_key_exists($id_genei_carrier, $arrayPrices)) {
            if (file_exists($fichero)) {
                file_put_contents(
                    $fichero,
                    date('Y-m-d h:i:s').': calculo variaciones',
                    FILE_APPEND | LOCK_EX
                );
            }
            if ((float)$arrayPrices[$id_genei_carrier]['importe']>=2) {
                if (Module::getInstanceByName('genei')->getCarrierVariationFreeAmount($id_genei_carrier) > 0
                    && Cart::getOrderTotal(true, Cart::ONLY_PRODUCTS_WITHOUT_SHIPPING) >=
                    Module::getInstanceByName('genei')->getCarrierVariationFreeAmount($id_genei_carrier)) {
                    if (file_exists($fichero)) {
                        file_put_contents($fichero, date('Y-m-d h:i:s').': retorno 0', FILE_APPEND | LOCK_EX);
                    }
                    return 0;
                } else {
                    if (file_exists($fichero)) {
                        file_put_contents(
                            $fichero,
                            date('Y-m-d h:i:s').': retorno importe '.$arrayPrices[$id_genei_carrier]['importe'],
                            FILE_APPEND | LOCK_EX
                        );
                    }
                    return($arrayPrices[$id_genei_carrier]['importe']);
                }
            } else {
                return false;
            }
        } else {
            return false;
        }
        return false;
    }
}
