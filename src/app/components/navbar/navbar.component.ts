import { Component, OnInit, ViewChild } from '@angular/core';
import { Router, NavigationEnd } from '@angular/router';
import { MenuService } from '../../services/menu/menu.service';
import { Menu } from '../../models/menu/menu';
import { AuthService } from '../../services/auth/auth.service';
import { Usuario } from './../../models/usuario/usuario';
import { UsuarioService } from '../../services/seguridad/usuario.service';
import { AlertasService } from '../../services/alertas/alertas.service';

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
    private alertasService:AlertasService

  ) {}

  ngOnInit(): void {
    this.loadMenus();
  }

  loadMenus() {
    this.loading = true;
    this.usuarioActual = this.authService.getUsuarioActual();
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
    }
  }

  cambiarClave() {
    // Verifica si las contraseñas son iguales
    if (this.Clave === this.claveRepetida) {
      // Si las contraseñas coinciden, entonces procede a enviar la solicitud al servicio
      this.usuarioActual = this.authService.getUsuarioActual();
      this.datosUsuario.IdUsuario = this.usuarioActual.UsuarioId;
      this.datosUsuario.Usuario = this.usuarioActual.UsuarioPersonal;
      this.datosUsuario.Clave = this.Clave;

      const Token = localStorage.getItem('Token');
      if (Token) {
        this.usuarioService.editar(this.datosUsuario, Token).subscribe(
          (response) => {
            if (response="200"){
              this.alertasService.OkAlert('Ok', 'Contraseña Cambiada con Éxito');
            } else {
              this.alertasService.ErrorAlert('Credenciales incorrectas', 'Por favor intenta de nuevo.');
            }
          },
          (error) => {
            console.error('Error al actualizar contraseña', error);
          }
        );
      }
    } else {
      // Si las contraseñas no coinciden, muestra un mensaje de error
      console.error('Las contraseñas no coinciden');
      // Aquí puedes mostrar un mensaje al usuario indicando que las contraseñas no coinciden
    }
  }
  logout() {
    this.loading = true;
    this.authService.logout();
  }
}
