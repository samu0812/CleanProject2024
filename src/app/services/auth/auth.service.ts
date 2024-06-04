import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { Usuario } from './../../models/usuario/usuario';


@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private sesion = false;
  private usuarioActual: Usuario | null = null;
  private temporizadorInactividad: any;
  private TIEMPO_INACTIVIDAD_MS: number = 3600000;

  constructor(private router: Router) {}

  setAuthenticated(status: boolean, usuario?: Usuario) {
    this.sesion = status;
    if (usuario) {
      this.usuarioActual = usuario;
    }
  }

  isAuthenticatedUser(): boolean {
    return this.sesion;
  }

  getUsuarioActual(): Usuario | null {
    return this.usuarioActual;
  }

  iniciarSeguimientoInactividad() {
    this.inicializarTemporizadorInactividad();
    document.addEventListener('mousemove', this.resetearTemporizadorInactividad.bind(this));
    document.addEventListener('keypress', this.resetearTemporizadorInactividad.bind(this));
  }

  detenerSeguimientoInactividad() {
    clearTimeout(this.temporizadorInactividad);
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
