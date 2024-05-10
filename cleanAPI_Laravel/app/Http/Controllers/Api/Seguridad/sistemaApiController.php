<?php

namespace App\Http\Controllers\Api\Seguridad;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;

class sistemaApiController
{
    public function SP_SistemaAPIs(Request $request) {
        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'metodo' => 'required|string', // Método de la API (GET, POST, PUT, DELETE)
            'nombre' => 'required|string', // Nombre de la API
        ]);

        // Si la validación falla, devolver la respuesta correspondiente
        if ($validator->fails()) {
            return response()->json([
                'message' => 'Error en la validación de los datos',
                'errors' => $validator->errors(),
                'status' => 400,
            ], 400);
        }

        // Obtener el método y el nombre de la API de la solicitud
        $metodo = $request->input('metodo');
        $nombre = $request->input('nombre');

        // Ejecutar el procedimiento almacenado SP_SistemaAPIs
        $sistemaAPIs = DB::select('CALL SP_SistemaAPIs(?, ?)', [$metodo, $nombre]);

        // Verificar si el conjunto de menús está vacío
        if (empty($sistemaAPIs)) {
            return response()->json([
                'message' => 'No se encontraron APIs con el método '.$metodo.' y el nombre '.$nombre,
                'status' => 404,
            ], 404);
        }

        return response()->json([
            'message' => 'OK',
            'status' => 200,
            'sistemaAPIs' => $sistemaAPIs,
        ], 200);


    }
}
