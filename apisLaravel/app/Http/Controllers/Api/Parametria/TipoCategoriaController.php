<?php

namespace App\Http\Controllers\Api\Parametria;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;

class TipoCategoriaController extends Controller
{
    public function SPL_TipoCategoria(Request $request) {
        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'tipoLista' => 'required|integer',
        ]);

        // Si la validación falla, devolver la respuesta correspondiente
        if ($validator->fails()) {
            return response()->json([
                'message' => 'Error en la validación de los datos',
                'errors' => $validator->errors(),
                'status' => 400,
            ], 400);
        }

        // Obtener los datos del cuerpo de la solicitud
        $tipoLista = $request->input('tipoLista');
        
        // Ejecutar el procedimiento almacenado SPL_TipoProducto
        $resultados = DB::select('CALL SPL_TipoCategoria(?)', [$tipoLista]);

        // Obtener el mensaje del resultado
        $mensaje = isset($resultados[0]->Message) ? $resultados[0]->Message : null;

        // Verificar si el mensaje es nulo (para el caso de que el tipo de lista sea válido)
        if ($mensaje === null) {
            // Devolver los resultados como respuesta
            return response()->json([
                'message' => 'OK',
                'status' => 200,
                'TipoProducto' => $resultados,
            ], 200);
        } else {
            // Devolver el mensaje de error
            return response()->json([
                'message' => $mensaje,
                'status' => 400,
            ], 400);
        }
    }

    public function SPA_TipoCategoria(Request $request) {

        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'descripcion' => 'required|string|max:50',
            'token' => 'required|string|max:500',
        ]);

        // Si la validación falla, devolver la respuesta correspondiente
        if ($validator->fails()) {
            return response()->json([
                'message' => 'Error en la validación de los datos',
                'errors' => $validator->errors(),
                'status' => 400,
            ], 400);
        }

        // Obtener los datos del cuerpo de la solicitud
        $descripcion = $request->input('descripcion');
        $token = $request->input('token');

        // Ejecutar el procedimiento almacenado SPA_TipoProducto
        $resultados = DB::select('CALL SPA_TipoCategoria(?, ?)', [$descripcion, $token]);

        // Obtener el mensaje del resultado
        $mensaje = $resultados[0]->v_Message;

        // Devolver la respuesta según el mensaje obtenido
        if ($mensaje === 'OK') {
            return response()->json([
                'message' => 'OK',
                'status' => 200,
            ], 200);
        } else {
            return response()->json([
                'message' => $mensaje,
                'status' => 400,
            ], 400);
        }

    }

    public function SPM_TipoCategoria(Request $request) {
        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'id' => 'required|integer',
            'descripcion' => 'required|string|max:50',
            'token' => 'required|string|max:500',
        ]);

        // Si la validación falla, devolver la respuesta correspondiente
        if ($validator->fails()) {
            return response()->json([
                'message' => 'Error en la validación de los datos',
                'errors' => $validator->errors(),
                'status' => 400,
            ], 400);
        }

        // Obtener los datos del cuerpo de la solicitud
        $id = $request->input('id');
        $descripcion = $request->input('descripcion');
        $token = $request->input('token');

        // Ejecutar el procedimiento almacenado SPM_TipoProducto
        $resultados = DB::select('CALL SPM_TipoCategoria(?, ?, ?)', [$id, $descripcion, $token]);

        // Obtener el mensaje del resultado
        $mensaje = $resultados[0]->v_Message;

        // Determinar el estado de la operación según el mensaje
        if ($mensaje === 'OK') {
            return response()->json([
                'message' => 'OK',
                'status' => 200,
            ], 200);
        } else {
            return response()->json([
                'message' => $mensaje,
                'status' => 400, // Bad Request
            ], 400);
        }
    }

    public function SPB_TipoCategoria(Request $request) {

        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'id' => 'required|integer',
            'token' => 'required|string|max:500',
        ]);

        // Si la validación falla, devolver la respuesta correspondiente
        if ($validator->fails()) {
            return response()->json([
                'message' => 'Error en la validación de los datos',
                'errors' => $validator->errors(),
                'status' => 400,
            ], 400);
        }

        // Obtener los datos del cuerpo de la solicitud
        $id = $request->input('id');
        $token = $request->input('token');

        // Ejecutar el procedimiento almacenado SPB_TipoProducto
        $resultados = DB::select('CALL SPB_TipoCategoria(?, ?)', [$id, $token]);

        // Obtener el mensaje del resultado
        $mensaje = $resultados[0]->v_Message;

        // Determinar el estado de la operación según el mensaje
        if ($mensaje === 'OK') {
            return response()->json([
                'message' => 'OK',
                'status' => 200,
            ], 200);
        } else {
            return response()->json([
                'message' => $mensaje,
                'status' => 400, // Bad Request
            ], 400);
        }

    }    

    public function SPH_TipoCategoria(Request $request) {

        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'id' => 'required|integer',
            'token' => 'required|string|max:500',
        ]);

        // Si la validación falla, devolver la respuesta correspondiente
        if ($validator->fails()) {
            return response()->json([
                'message' => 'Error en la validación de los datos',
                'errors' => $validator->errors(),
                'status' => 400,
            ], 400);
        }

        // Obtener los datos del cuerpo de la solicitud
        $id = $request->input('id');
        $token = $request->input('token');

        // Ejecutar el procedimiento almacenado SPH_TipoProducto
        $resultados = DB::select('CALL SPH_TipoCategoria(?, ?)', [$id, $token]);

        // Obtener el mensaje del resultado
        $mensaje = $resultados[0]->v_Message;

        // Determinar el estado de la operación según el mensaje
        if ($mensaje === 'OK') {
            return response()->json([
                'message' => 'OK',
                'status' => 200,
            ], 200);
        } else {
            return response()->json([
                'message' => $mensaje,
                'status' => 400, // Bad Request
            ], 400);
        }
    }

}
