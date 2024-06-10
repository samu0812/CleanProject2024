<?php

namespace App\Http\Controllers\Api\Seguridad;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;

class UsuariosController extends Controller

{
    public function SPL_Usuarios(Request $request) {
        // Ejecutar el procedimiento almacenado SPL_Usuarios
        $resultados = DB::select('CALL SPL_Usuarios()');

        // Devolver los resultados obtenidos
        return response()->json([
            'message' => 'OK',
            'usuarios' => $resultados,
            'status' => 200,
        ], 200);

    }

    public function SPA_Usuarios(Request $request) {
        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'idUsuarioCarga' => 'required|integer',
            'id_persona' => 'required|integer',
            'nombreUsuario' => [
                'required',
                'string',
                'min:8',
                function ($attribute, $value, $fail) {
                    if (!preg_match('/[0-9]/', $value)) {
                        $fail('El nombre de usuario debe contener al menos un número.');
                    }
                },
            ],
            'clave' => [
                'required',
                'string',
                'min:8',
                function ($attribute, $value, $fail) {
                    if (!preg_match('/[A-Z]/', $value)) {
                        $fail('La contraseña debe contener al menos una letra mayúscula.');
                    }
                    if (!preg_match('/[0-9]/', $value)) {
                        $fail('La contraseña debe contener al menos un número.');
                    }
                },
            ],
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
        $idUsuarioCarga = $request->input('idUsuarioCarga');
        $id_persona = $request->input('id_persona');
        $nombreUsuario = $request->input('nombreUsuario');
        $clave = $request->input('clave');

        echo $idUsuarioCarga  . ' ' . $id_persona . ' ' . $nombreUsuario . ' ' . $clave;

    }

    public function SPM_Usuarios(Request $request) {
        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'id_usuario' => 'required|integer',
            'nuevo_usuario' => [
                'nullable',
                'string',
                'min:8',
                function ($attribute, $value, $fail) {
                    if (!preg_match('/[0-9]/', $value)) {
                        $fail('El nuevo nombre de usuario debe contener al menos un número.');
                    }
                },
            ],
            'nueva_clave' => [
                'nullable',
                'string',
                'min:8',
                function ($attribute, $value, $fail) {
                    if (!empty($value) && !preg_match('/[[:upper:]]/', $value)) {
                        $fail('La nueva contraseña debe contener al menos una letra mayúscula.');
                    }
                    if (!empty($value) && !preg_match('/[0-9]/', $value)) {
                        $fail('La nueva contraseña debe contener al menos un número.');
                    }
                },
            ],
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
        $id_usuario = $request->input('id_usuario');
        $nuevo_usuario = $request->input('nuevo_usuario');
        $nueva_clave = $request->input('nueva_clave');

        echo $id_usuario  . ' ' . $nuevo_usuario . ' ' . $nueva_clave;

    }

    public function SPB_Usuarios(Request $request) {
        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'id_usuario' => 'required|integer',
        ]);

        // Si la validación falla, devolver la respuesta correspondiente
        if ($validator->fails()) {
            return response()->json([
                'message' => 'Error en la validación de los datos',
                'errors' => $validator->errors(),
                'status' => 400,
            ], 400);
        }

        // Obtener el id_usuario del cuerpo de la solicitud
        $id_usuario = $request->input('id_usuario');

        echo $id_usuario;

    }




}
