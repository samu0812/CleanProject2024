import { Component, OnInit, Inject, PLATFORM_ID } from '@angular/core';
import { Router } from '@angular/router';
import { MenuService } from '../../services/menu/menu.service';
import { Menu } from '../../models/menu/menu';
import { AuthService } from '../../services/auth/auth.service';
import { Usuario } from './../../models/usuario/usuario';
import { UsuarioService } from '../../services/seguridad/usuario.service';
import { AlertasService } from '../../services/alertas/alertas.service';
import { isPlatformBrowser } from '@angular/common';


declare var bootstrap: any;

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.css']
})
export class NavbarComponent implements OnInit {
  Menues: Menu[] = [];
  usuarioActual: Usuario | null = null;
  loading: boolean = true;
  Clave: string = '';
  claveRepetida: string = '';
  datosUsuario: any = { IdUsuario: '', Usuario: '', Clave: '' };

  constructor(
    private router: Router,
    private menuService: MenuService,
    private authService: AuthService,
    private usuarioService: UsuarioService,
    private alertasService: AlertasService,
    @Inject(PLATFORM_ID) private platformId: Object
  ) {}

  ngOnInit(): void {
    this.loadMenus();
  }

  loadMenus() {
    this.loading = true;
    this.usuarioActual = this.authService.getUsuarioActual();

    if (isPlatformBrowser(this.platformId)) {
      const Token = localStorage.getItem('Token');
      if (Token) {
        this.menuService.getMenuItems(Token).subscribe(
          (response) => {
            this.Menues = response.Menues;
            this.loading = false;
          },
          (error) => {
            console.error('Error', error);
            this.loading = false;
          }
        );
      } else {
        this.loading = false;
      }
    }
  }

  cambiarClave() {
    // Verificar si el usuario está autenticado
    if (!this.authService.isAuthenticatedUser()) {
      this.alertasService.ErrorAlert('No Autenticado', 'Debes iniciar sesión para cambiar tu contraseña.');
      return;
    }

    if (this.Clave === this.claveRepetida) {
      this.usuarioActual = this.authService.getUsuarioActual();
      if (this.usuarioActual) {
        this.datosUsuario.IdUsuario = this.usuarioActual.UsuarioId;
        this.datosUsuario.Usuario = this.usuarioActual.UsuarioPersonal;
        this.datosUsuario.Clave = this.Clave;
        const Token = localStorage.getItem('Token');

        if (isPlatformBrowser(this.platformId)) {
          if (Token) {
            console.log("entro");
            this.usuarioService.editar(this.datosUsuario, Token).subscribe(
              (response) => {
                if (response.Status === 200) {
                  this.alertasService.OkAlert('Ok', 'Contraseña Cambiada con Éxito');
                  this.closeModal('CambiarClaveModal');
                } else {
                  this.alertasService.ErrorAlert('Credenciales incorrectas', 'Por favor intenta de nuevo.');
                }
              },
              (error) => {
                console.error('Error al actualizar contraseña', error);
              }
            );
          }
        }
      } else {
        this.alertasService.ErrorAlert('Error', 'No se pudo obtener la información del usuario.');
      }
    } else {
      console.error('Las contraseñas no coinciden');
      this.alertasService.ErrorAlert('Error', 'Las contraseñas no coinciden.');
    }
  }

  closeModal(modalId: string) {
    const modalElement = document.getElementById(modalId);
    if (modalElement) {
      const modal = bootstrap.Modal.getInstance(modalElement) || new bootstrap.Modal(modalElement);
      modal.hide();
      // Restablecer los valores de las contraseñas
      this.Clave = '';
      this.claveRepetida = '';
    }
  }
  

  logout() {
    this.loading = true;
    this.authService.logout();

  }
}
