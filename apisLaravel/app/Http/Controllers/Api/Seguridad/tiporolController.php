<?php

namespace App\Http\Controllers\Api\Seguridad;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;

class tiporolController extends Controller
{
    public function SPA_TipoRol(Request $request) {
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

        // Ejecutar el procedimiento almacenado SPA_TipoRol
        $resultado = DB::select('CALL SPA_TipoRol(?, ?)', [$descripcion, $token]);

        // Verificar si el resultado está vacío
        if (empty($resultado)) {
            return response()->json([
                'message' => 'Error al ejecutar el procedimiento almacenado',
                'status' => 400,
            ], 400);
        }

        // Obtener el mensaje del resultado
        $mensaje = $resultado[0]->v_Message;

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

    public function SPM_TipoRol(Request $request) {
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

        // Ejecutar el procedimiento almacenado SPM_TipoRol
        $resultado = DB::select('CALL SPM_TipoRol(?, ?, ?)', [$id, $descripcion, $token]);

        // Verificar si el resultado está vacío
        if (empty($resultado)) {
            return response()->json([
                'message' => 'Error al ejecutar el procedimiento almacenado',
                'status' => 400,
            ], 400);
        }

        // Obtener el mensaje del resultado
        $mensaje = $resultado[0]->v_Message;

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

    public function SPB_TipoRol(Request $request) {
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


        // Ejecutar el procedimiento almacenado SPB_TipoRol
        $resultado = DB::select('CALL SPB_TipoRol(?, ?)', [$id, $token]);

        // Verificar si el resultado está vacío
        if (empty($resultado)) {
            return response()->json([
                'message' => 'Error al ejecutar el procedimiento almacenado',
                'status' => 400,
            ], 400);
        }


        // Obtener el mensaje del resultado
        $mensaje = $resultado[0]->v_Message;

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

    public function SPL_TipoRol(Request $request) {

        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'tipo_lista' => 'required|integer|in:1,2',
        ]);

        // Si la validación falla, devolver la respuesta correspondiente
        if ($validator->fails()) {
            return response()->json([
                'message' => 'Error en la validación de los datos',
                'errors' => $validator->errors(),
                'status' => 400,
            ], 400);
        }

        // Obtener el tipo de lista del cuerpo de la solicitud
        $tipoLista = $request->input('tipo_lista');

        // Ejecutar el procedimiento almacenado SPL_TipoRol
        $resultado = DB::select('CALL SPL_TipoRol(?)', [$tipoLista]);

        // Verificar si el resultado está vacío
        if (empty($resultado)) {
            return response()->json([
                'message' => 'Error al ejecutar el procedimiento almacenado',
                'status' => 400,
            ], 400);
        }

        

        // Devolver los resultados como respuesta
        return response()->json([
            'message' => 'OK',
            'status' => 200,
            'tiposRol' => $resultado,
        ], 200);

    }


    public function SPH_TipoRol(Request $request) {

        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'idTipoRol' => 'required|integer', // Cambiar el nombre según corresponda
            'token' => 'required|string|max:500', // Asegúrate de que coincide con el nombre del parámetro en tu procedimiento almacenado
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
        $idTipoRol = $request->input('idTipoRol');
        $token = $request->input('token');

        // Ejecutar el procedimiento almacenado SPH_TipoRol
        $resultado = DB::select('CALL SPH_TipoRol(?, ?)', [$idTipoRol, $token]);

        // Verificar si el resultado está vacío
        if (empty($resultado)) {
            return response()->json([
                'message' => 'Error al ejecutar el procedimiento almacenado',
                'status' => 400,
            ], 400);
        }

        // Obtener el mensaje del resultado
        $mensaje = $resultado[0]->v_Message;

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
