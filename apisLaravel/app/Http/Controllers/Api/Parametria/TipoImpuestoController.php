<?php

namespace App\Http\Controllers\Api\Parametria;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;

class TipoImpuestoController extends Controller
{
    public function SPL_TipoImpuesto(Request $request) {
        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'TipoLista' => 'required|integer',
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
        $tipoLista = $request->input('TipoLista');
    
        // Ejecutar el procedimiento almacenado SPL_TipoProducto
        $resultados = DB::select('CALL SPL_TipoImpuesto(?)', [$tipoLista]);

        // Obtener el mensaje del resultado
        $mensaje = isset($resultados[0]->Message) ? $resultados[0]->Message : null;

        // Verificar si el mensaje es nulo (para el caso de que el tipo de lista sea válido)
        if ($mensaje === null) {
            // Devolver los resultados como respuesta
            return response()->json([
                'Message' => 'OK',
                'Status' => 200,
                'TipoProducto' => $resultados,
            ], 200);
        } else {
            // Devolver el mensaje de error
            return response()->json([
                'Message' => $mensaje,
                'Status' => 400,
            ], 400);
        }
    }


    public function SPA_TipoImpuesto(Request $request) {

        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'Descripcion' => 'required|string|max:50',
            'Porcentaje'=> 'required|integer|max:500',
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
        $descripcion = $request->input('Descripcion');
        $porcentaje = $request->input('Porcentaje');
        $token = $request->input('Token');

        // Ejecutar el procedimiento almacenado SPA_TipoProducto
        $resultados = DB::select('CALL SPA_TipoImpuesto(?, ?,?)', [$descripcion, $porcentaje, $token]);

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

    public function SPM_TipoImpuesto(Request $request) {
        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'IdTipoImpuesto' => 'required|integer',
            'Descripcion' => 'required|string|max:50',
            'Porcentaje'=> 'required|integer|max:500',
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
        $id = $request->input('IdTipoImpuesto');
        $descripcion = $request->input('Descripcion');
        $porcentaje = $request->input('Porcentaje');
        $token = $request->input('Token');

        // Ejecutar el procedimiento almacenado SPM_TipoProducto
        $resultados = DB::select('CALL SPM_TipoImpuesto(?, ?, ?,?)', [$id, $descripcion, $porcentaje , $token]);

        // Obtener el mensaje del resultado
        $mensaje = $resultados[0]->v_Message;

        // Determinar el estado de la operación según el mensaje
        if ($mensaje === 'OK') {
            return response()->json([
                'Message' => 'OK',
                'Status' => 200,
            ], 200);
        } else {
            return response()->json([
                'Message' => $mensaje,
                'Status' => 400, // Bad Request
            ], 400);
        }
    }

    public function SPB_TipoImpuesto(Request $request) {

        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'IdTipoImpuesto' => 'required|integer',
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
        $id = $request->input('IdTipoImpuesto');
        $token = $request->input('Token');

        // Ejecutar el procedimiento almacenado SPB_TipoProducto
        $resultados = DB::select('CALL SPB_TipoImpuesto(?, ?)', [$id, $token]);

        // Obtener el mensaje del resultado
        $mensaje = $resultados[0]->v_Message;

        // Determinar el estado de la operación según el mensaje
        if ($mensaje === 'OK') {
            return response()->json([
                'Message' => 'OK',
                'Status' => 200,
            ], 200);
        } else {
            return response()->json([
                'Message' => $mensaje,
                'Status' => 400, // Bad Request
            ], 400);
        }

    }    

    public function SPH_TipoImpuesto(Request $request) {

        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'IdTipoImpuesto' => 'required|integer',
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
        $id = $request->input('IdTipoImpuesto');
        $token = $request->input('Token');

        // Ejecutar el procedimiento almacenado SPH_TipoProducto
        $resultados = DB::select('CALL SPH_TipoImpuesto(?, ?)', [$id, $token]);

        // Obtener el mensaje del resultado
        $mensaje = $resultados[0]->v_Message;

        // Determinar el estado de la operación según el mensaje
        if ($mensaje === 'OK') {
            return response()->json([
                'Message' => 'OK',
                'Status' => 200,
            ], 200);
        } else {
            return response()->json([
                'Message' => $mensaje,
                'Status' => 400, // Bad Request
            ], 400);
        }
    }


}
