<?php

namespace App\Http\Controllers\Api\Parametria;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;


class TipoPermisoDetalleController extends Controller
{
    public function SPL_TipoPermisoDetalle(Request $request) {
        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'IdTipoPermiso' => 'nullable|integer',
        ]);

        // Si la validación falla, devolver la respuesta correspondiente
        if ($validator->fails()) {
            return response()->json([
                'Message' => 'Error en la validación de los datos',
                'Errors' => $validator->errors(),
                'Status' => 400,
            ], 400);
        }

        // Obtener el ID del tipo de permiso de la solicitud
        $idTipoPermiso = $request->input('IdTipoPermiso');

        // Ejecutar el procedimiento almacenado SPL_TipoPermisoDetalle
        $resultados = DB::select('CALL SPL_TipoPermisoDetalle(?)', [$idTipoPermiso]);

        // Verificar si el primer resultado tiene un campo 'v_Message'
        if (isset($resultados[0]->v_Message)) {
            // Obtener el mensaje del resultado
            $mensaje = $resultados[0]->v_Message;
            // Determinar el estado de la operación según el mensaje
            if ($mensaje === 'OK') {
                // Devolver los resultados como respuesta
                return response()->json([
                    'Message' => 'OK',
                    'Status' => 200,
                    'TipoPermisoDetalles' => $resultados,
                ], 200);
            } else {
                return response()->json([
                    'Message' => $mensaje,
                    'Status' => 400, // Bad Request
                ], 400);
            }
        } else {
            // Si no hay un campo 'v_Message', devolver los resultados como respuesta
            return response()->json([
                'Message' => 'OK',
                'Status' => 200,
                'TipoPermisoDetalles' => $resultados,
            ], 200);
        }
    }
}
