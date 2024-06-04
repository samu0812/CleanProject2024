import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { Usuario } from './../../models/usuario/usuario'; // Asegúrate de importar tu modelo de usuario
import { Observable } from 'rxjs';
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private sesion = false;
  private usuarioActual: Usuario | null = null; // Añade esta línea para almacenar el usuario actual
  private temporizadorInactividad: any;
  private TIEMPO_INACTIVIDAD_MS: number = 3600000; // 1 hora en milisegundos

  constructor(
    private router: Router,
    private http: HttpClient
  ) {}

  // Método para establecer el estado de autenticación y el usuario actual
  setAuthenticated(status: boolean, usuario?: Usuario) {
    this.sesion = status;
    if (usuario) {
      this.usuarioActual = usuario;
    }
  }

  // Método para verificar si el usuario está autenticado
  isAuthenticatedUser(): boolean {
    return this.sesion;
  }

  // Método para obtener el usuario actual
  getUsuarioActual(): Usuario | null {
    return this.usuarioActual;
  }

  iniciarSeguimientoInactividad() {
    this.inicializarTemporizadorInactividad();

    // Escucha eventos de interacción del usuario para resetear el temporizador
    document.addEventListener('mousemove', this.resetearTemporizadorInactividad.bind(this));
    document.addEventListener('keypress', this.resetearTemporizadorInactividad.bind(this));
  }

  detenerSeguimientoInactividad() {
    clearTimeout(this.temporizadorInactividad);

    // Remueve los event listeners cuando la inactividad ya no necesita ser rastreada
    document.removeEventListener('mousemove', this.resetearTemporizadorInactividad.bind(this));
    document.removeEventListener('keypress', this.resetearTemporizadorInactividad.bind(this));
  }

  private inicializarTemporizadorInactividad() {
    this.temporizadorInactividad = setTimeout(() => {
      this.router.navigate(['/login']);
    }, this.TIEMPO_INACTIVIDAD_MS);
  }

  private resetearTemporizadorInactividad() {
    clearTimeout(this.temporizadorInactividad);
    this.inicializarTemporizadorInactividad();
  }

}
