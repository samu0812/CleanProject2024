import { Component, OnInit } from '@angular/core';
import { MenuService } from '../../services/menu/menu.service';
import { Menu } from '../../models/menu/menu';

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.css']
})
export class NavbarComponent implements OnInit {
  menues: Menu[] = [];

  constructor(private menuService: MenuService) {}

  ngOnInit(): void {
    const token = localStorage.getItem('token');

    if (token) {
      this.menuService.getMenuItems(token).subscribe(
        (response) => {
          console.log(response);
          this.menues = response.menues;
        },
        (error) => {
          console.error('Error fetching menu items:', error);
        }
      );
    }
  }
}
