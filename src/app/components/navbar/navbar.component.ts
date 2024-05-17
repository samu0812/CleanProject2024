import { Component, OnInit } from '@angular/core';
import { MenuService } from '../../services/menu/menu.service';
import { Menu } from '../../models/menu/menu';
import { AuthService } from '../../services/auth/auth.service'; // Importa el AuthService

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.css']
})
export class NavbarComponent implements OnInit {
  Menues: Menu[] = [];
  isAuthenticated: boolean = false; // Variable para almacenar el estado de autenticación

  constructor(
    private menuService: MenuService,
    private authService: AuthService // Inyecta AuthService
  ) {}

  ngOnInit(): void {
    this.isAuthenticated = this.authService.isAuthenticatedUser(); // Verifica si el usuario está autenticado

    if (this.isAuthenticated) {
      const Token = localStorage.getItem('Token');

      if (Token) {
        this.menuService.getMenuItems(Token).subscribe(
          (response) => {
            this.Menues = response.Menues;
          },
          (error) => {
            console.error('Error fetching menu items:', error);
          }
        );
      }
    }
  }
}
