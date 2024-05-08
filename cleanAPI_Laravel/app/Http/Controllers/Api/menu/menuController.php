<?php

namespace App\Http\Controllers\Api\menu;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;

class menuController extends Controller{
    public function SP_GetMenu(Request $request) {
        // Validar el token
        $validator = Validator::make($request->all(), [
            'token' => 'required|string', // Puedes agregar reglas de validación adicionales según tus necesidades
        ]);

        // Si la validación falla, devolver la respuesta correspondiente
        if ($validator->fails()) {
            return response()->json([
                'message' => 'Error en la validación del token',
                'errors' => $validator->errors(),
                'status' => 400,
            ], 400);
        }


        // Obtener el token de la solicitud
        $token = $request->input('token');

        // Ejecutar el procedimiento almacenado SP_GetMenu
        $menues = DB::select('CALL SP_GetMenu(?)', [$token]);

        // Procesar los resultados del procedimiento almacenado según sea necesario
        // En este ejemplo, simplemente devolvemos los resultados como parte de la respuesta JSON
        return response()->json([
            'message' => 'OK',
            'status' => 200,
            'menues' => $menues,
        ], 200);

    }

    public function SP_GetSubMenu (Request $request){
        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'token' => 'required|string',
            'id_menu' => 'required|integer',
        ]);


        // Si la validación falla, devolver la respuesta correspondiente
        if ($validator->fails()) {
            return response()->json([
                'message' => 'Error en la validación de los datos',
                'errors' => $validator->errors(),
                'status' => 400,
            ], 400);
        }

        // Obtener el token y el ID del menú del cuerpo de la solicitud
        $token = $request->input('token');
        $id_menu = $request->input('id_menu');

        // Ejecutar el procedimiento almacenado y obtener los menús
        $subMenues = DB::select('CALL SP_GetSubMenu(?, ?)', [$token, $id_menu]);

        // Verificar si el resultado está vacío
        if (empty($subMenues)) {
            return response()->json([
                'message' => 'Error al ejecutar el procedimiento almacenado',
                'status' => 400,
            ], 400);
        }

        // Devolver los menús como respuesta
        return response()->json([
            'message' => 'OK',
            'status' => 200,
            'menus' => $subMenues,
        ], 200);
    }

    public function SP_GetImagenSubMenu (Request $request) {

        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'path' => 'required|string',
        ]);

        // Si la validación falla, devolver la respuesta correspondiente
        if ($validator->fails()) {
            return response()->json([
                'message' => 'Error en la validación de los datos',
                'errors' => $validator->errors(),
                'status' => 400,
            ], 400);
        }

        // Obtener la ruta del submenú del cuerpo de la solicitud
        $path = $request->input('path');

        // Ejecutar el procedimiento almacenado y obtener los detalles de la imagen del submenú
        $imagenSubMenu = DB::select('CALL SP_GetImagenSubMenu(?)', [$path]);

        // Verificar si el resultado está vacío
        if (empty($imagenSubMenu)) {
            return response()->json([
                'message' => 'Error al ejecutar el procedimiento almacenado',
                'status' => 400,
            ], 400);
        }

        // Devolver los detalles de la imagen del submenú como respuesta
        return response()->json([
            'message' => 'OK',
            'status' => 200,
            'imagen_submenu' => $imagenSubMenu,
        ], 200);
    }


    public function SP_GetMenuUsuario (Request $request) {
        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'id_persona' => 'required|integer',
        ]);

        // Si la validación falla, devolver la respuesta correspondiente
        if ($validator->fails()) {
            return response()->json([
                'message' => 'Error en la validación de los datos',
                'errors' => $validator->errors(),
                'status' => 400,
            ], 400);
        }

        // Obtener el ID del usuario del cuerpo de la solicitud
        $idPersona = $request->input('id_persona');

        // Ejecutar el procedimiento almacenado y obtener los menús del usuario
        $menusUsuario = DB::select('CALL SP_GetMenuUsuario(?)', [$idPersona]);

        // Verificar si el conjunto de menús está vacío
        if (empty($menusUsuario)) {
            return response()->json([
                'message' => 'El ID de persona no existe en el sistema',
                'status' => 400,
            ], 400);
        }

        
        // Devolver los menús del usuario como respuesta
        return response()->json([
            'message' => 'OK',
            'status' => 200,
            'menus_usuario' => $menusUsuario,
        ], 200);
    }




    
}
