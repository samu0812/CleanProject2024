<?php

namespace App\Http\Controllers\Api\Parametria;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;

class SucursalController extends Controller
{

    public function SPL_Sucursal(Request $request) {
        echo 'llego';

    }

    public function SPA_Sucursal(Request $request) {
        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'IdTipoDomicilio' => 'required|integer',
            'Descripcion' => 'required|string|max:50',
            'Calle' => 'required|string|max:50',
            'Nro' => 'required|string|max:50',
            'Piso' => 'required|string|max:50',
            'Token' => 'required|string|max:500',
        ]);

        // Si la validación falla, devolver la respuesta correspondiente
        if ($validator->fails()) {
            return response()->json([
                'Message' => 'Error en la validación de los datos',
                'Errors' => $validator->errors(),
                'Status' => 400,
            ], 400);
        }

        // Obtener los datos del cuerpo de la solicitud
        $id_tipo_domicilio = $request->input('IdTipoDomicilio');
        $descripcion = $request->input('Descripcion');
        $calle = $request->input('Calle');
        $nro = $request->input('Nro');
        $piso = $request->input('Piso');
        $token = $request->input('Token');

        // Ejecutar el procedimiento almacenado SPA_Sucursal
        $resultados = DB::select('CALL SPA_Sucursal(?, ?, ?, ?, ?, ?)', [
            $id_tipo_domicilio, $descripcion, $calle, $nro, $piso, $token
        ]);

        // Obtener el mensaje del resultado
        $mensaje = $resultados[0]->v_Message;

        // Devolver la respuesta según el mensaje obtenido
        if ($mensaje === 'OK') {
            return response()->json([
                'Message' => 'OK',
                'Status' => 200,
            ], 200);
        } else {
            return response()->json([
                'Message' => $mensaje,
                'Status' => 400,
            ], 400);
        }

    }

    // no me valida si le ingreso cualquier idsucursal y iddomicilio
    public function SPM_Sucursal(Request $request) {

        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'IdSucursal' => 'required|integer',
            'IdDomicilio' => 'required|integer',
            'IdTipoDomicilio' => 'required|integer',
            'Descripcion' => 'required|string|max:50',
            'Calle' => 'required|string|max:50',
            'Nro' => 'required|string|max:50',
            'Piso' => 'required|string|max:50',
            'Token' => 'required|string|max:500',
        ]);

        // Si la validación falla, devolver la respuesta correspondiente
        if ($validator->fails()) {
            return response()->json([
                'Meesage' => 'Error en la validación de los datos',
                'Errors' => $validator->errors(),
                'Status' => 400,
            ], 400);
        }

        // Obtener los datos del cuerpo de la solicitud
        $id_sucursal = $request->input('IdSucursal');
        $id_domicilio = $request->input('IdDomicilio');
        $id_tipo_domicilio = $request->input('IdTipoDomicilio');
        $descripcion = $request->input('Descripcion');
        $calle = $request->input('Calle');
        $nro = $request->input('Nro');
        $piso = $request->input('Piso');
        $token = $request->input('Token');

        //echo "id_sucursal : $id_sucursal , id_domicilio : $id_domicilio id_tipo_domicilio: $id_tipo_domicilio, descripcion: $descripcion, calle: $calle, nro: $nro, piso: $piso, token: $token";

        // Ejecutar el procedimiento almacenado SPM_Sucursal
        $resultados = DB::select('CALL SPM_Sucursal(?, ?, ?, ?, ?, ?, ?, ?)', [
            $id_sucursal,
            $id_domicilio,
            $id_tipo_domicilio,
            $descripcion,
            $calle,
            $nro,
            $piso,
            $token
        ]);

        // Obtener el mensaje del resultado
        $mensaje = $resultados[0]->v_Message;

        // Devolver la respuesta según el mensaje obtenido
        if ($mensaje === 'OK') {
            return response()->json([
                'Message' => 'OK',
                'Status' => 200,
            ], 200);
        } else {
            return response()->json([
                'Message' => $mensaje,
                'Status' => 400,
            ], 400);
        }
    }
    // no me valida si le ingreso cualquier idsucursal y iddomicilio
    public function SPB_Sucursal(Request $request) {
        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'Id' => 'required|integer',
            'Token' => 'required|string|max:500',
        ]);

        // Si la validación falla, devolver la respuesta correspondiente
        if ($validator->fails()) {
            return response()->json([
                'Message' => 'Error en la validación de los datos',
                'errors' => $validator->errors(),
                'status' => 400,
            ], 400);
        }

        // Obtener los datos del cuerpo de la solicitud
        $id = $request->input('Id');
        $token = $request->input('Token');

        // Ejecutar el procedimiento almacenado SPB_Sucursal
        $resultados = DB::select('CALL SPB_Sucursal(?, ?)', [
            $id, $token
        ]);

        // Obtener el mensaje del resultado
        $mensaje = $resultados[0]->v_Message;

        // Devolver la respuesta según el mensaje obtenido
        if ($mensaje === 'OK') {
            return response()->json([
                'Message' => 'OK',
                'Status' => 200,
            ], 200);
        } else {
            return response()->json([
                'Message' => $mensaje,
                'Status' => 400,
            ], 400);
        }



    }



}
