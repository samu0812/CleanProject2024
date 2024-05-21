<?php

namespace App\Http\Controllers\Api\Parametria;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;

class TipoPersonaSistemaController extends Controller
{
    public function SPL_TipoPersonaSistema(Request $request) {
        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'tipoLista' => 'required|integer',
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
        $tipoLista = $request->input('tipoLista');

        // Ejecutar el procedimiento almacenado SPL_TipoPersonaSistema
        $resultados = DB::select('CALL SPL_TipoPersonaSistema(?)', [$tipoLista]);

        // Obtener el mensaje del resultado
        $mensaje = isset($resultados[0]->Message) ? $resultados[0]->Message : null;

        // Verificar si el mensaje es nulo (para el caso de que el tipo de lista sea válido)
        if ($mensaje === null) {
            // Devolver los resultados como respuesta
            return response()->json([
                'Message' => 'OK',
                'Status' => 200,
                'TipoPersonaSistema' => $resultados,
            ], 200);
        } else {
            // Devolver el mensaje de error
            return response()->json([
                'Message' => $mensaje,
                'Status' => 400,
            ], 400);
        }
    }

    public function SPA_TipoPersonaSistema(Request $request) {

        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'Descripcion' => 'required|string|max:50',
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
        $token = $request->input('Token');

        // Ejecutar el procedimiento almacenado SPA_TipoPersonaSistema
        $resultados = DB::select('CALL SPA_TipoPersonaSistema(?, ?)', [$descripcion, $token]);

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

    public function SPM_TipoPersonaSistema(Request $request) {

        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'IdTipoPersonaSistema' => 'required|integer',
            'Descripcion' => 'required|string|max:50',
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
        $id = $request->input('IdTipoPersonaSistema');
        $descripcion = $request->input('Descripcion');
        $token = $request->input('Token');


        // Ejecutar el procedimiento almacenado SPM_TipoPersonaSistema
        $resultados = DB::select('CALL SPM_TipoPersonaSistema(?, ?, ?)', [$id, $descripcion, $token]);

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

    public function SPB_TipoPersonaSistema(Request $request) {

        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'IdTipoPersonaSistema' => 'required|integer',
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
        $id = $request->input('IdTipoPersonaSistema');
        $token = $request->input('Token');

        // Ejecutar el procedimiento almacenado SPB_TipoPersonaSistema
        $resultados = DB::select('CALL SPB_TipoPersonaSistema(?, ?)', [$id, $token]);

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

    public function SPH_TipoPersonaSistema(Request $request) {

        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'IdTipoPersonaSistema' => 'required|integer',
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
        $id = $request->input('IdTipoPersonaSistema');
        $token = $request->input('Token');


        // Ejecutar el procedimiento almacenado SPH_TipoPersonaSistema
        $resultados = DB::select('CALL SPH_TipoPersonaSistema(?, ?)', [$id, $token]);

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
