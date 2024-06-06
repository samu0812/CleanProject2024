import { Component, OnInit } from '@angular/core';
import { Router, NavigationEnd } from '@angular/router'; // Importa el Router y NavigationEnd
import { MenuService } from '../../services/menu/menu.service';
import { Menu } from '../../models/menu/menu';
import { AuthService } from '../../services/auth/auth.service';
import { Usuario } from './../../models/usuario/usuario';

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.css']
})
export class NavbarComponent implements OnInit {
  Menues: Menu[] = [];
  usuarioActual: Usuario | null = null;
  loading: boolean = true;

  constructor(
    private router: Router, // Inyecta el Router
    private menuService: MenuService,
    private authService: AuthService
  ) {}

  ngOnInit(): void {
    this.loadMenus(); // Carga los menús cuando se inicialice el componente
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
  logout() {
    this.loading = true;
    this.authService.logout();
  }
}
