<?php

namespace App\Http\Controllers\Api\Seguridad;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;

class rolModuloController extends Controller
{
    public function SPL_RolModulo(Request $request) {

            // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'idTipoRol' => 'required|integer',
            'tipoLista' => 'required|integer|in:1,2', // 1 para activo, 2 para baja
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
        $tipoLista = $request->input('tipoLista');

        // Ejecutar el procedimiento almacenado SPL_RolModulo
        $resultado = DB::select('CALL SPL_RolModulo(?, ?)', [$idTipoRol, $tipoLista]);

        // Verificar si el resultado está vacío
        if (empty($resultado)) {
            return response()->json([
                'message' => 'El idTipoRol proporcionado no existe o no tiene relacionado ningun modulo',
                'status' => 400,
            ], 400);
        }

        // Devolver los resultados como respuesta
        return response()->json([
            'message' => 'OK',
            'status' => 200,
            'rolModulos' => $resultado,
        ], 200);

    }

    public function SPA_RolModulo(Request $request) {

        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'idTipoRol' => 'required|integer',
            'idTipoModulo' => 'required|integer',
            'idTipoPermiso' => 'required|integer',
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
        $idTipoRol = $request->input('idTipoRol');
        $idTipoModulo = $request->input('idTipoModulo');
        $idTipoPermiso = $request->input('idTipoPermiso');
        $token = $request->input('token');

        // Ejecutar el procedimiento almacenado SPA_RolModulo
        $resultado = DB::select('CALL SPA_RolModulo(?, ?, ?, ?)', [$idTipoRol, $idTipoModulo, $idTipoPermiso, $token]);

        // Verificar si el resultado está vacío
        if (empty($resultado)) {
            return response()->json([
                'message' => 'Error al ejecutar el procedimiento almacenado',
                'status' => 400,
            ], 400);
        }

        // Obtener el mensaje del resultado
        $mensaje = $resultado[0]->Message;
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

    public function SPB_RolModulo(Request $request) {

            // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'idRolModulo' => 'required|integer',
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
        $idRolModulo = $request->input('idRolModulo');
        $token = $request->input('token');

        // Ejecutar el procedimiento almacenado SPB_RolModulo
        $resultado = DB::select('CALL SPB_RolModulo(?, ?)', [$idRolModulo, $token]);

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


    

    public function SPH_RolModulo(Request $request) {
    
        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'idRolModulo' => 'required|integer',
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
        $idRolModulo = $request->input('idRolModulo');
        $token = $request->input('token');

        // Ejecutar el procedimiento almacenado SPH_RolModulo
        $resultado = DB::select('CALL SPH_RolModulo(?, ?)', [$idRolModulo, $token]);

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
