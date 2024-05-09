import { Component, OnInit, Input } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { MenuService } from '../../../services/menu/menu.service';
import { Menu } from '../../../models/menu/menu';


@Component({
  selector: 'app-submenu',
  templateUrl: './submenu.component.html',
  styleUrls: ['./submenu.component.css']
})
export class SubmenuComponent implements OnInit {
  menues: Menu[] = [];
  respuesta: Menu[] = [];

  constructor(private route: ActivatedRoute, private menuService: MenuService) {}

  ngOnInit(): void {
    this.route.params.subscribe(params => {
      const id_menu = +params['id'];
      const token = localStorage.getItem('token');

      if (token !== null) {
        this.menuService.getSubMenuItems(token, id_menu).subscribe( data=>{
          this.respuesta = data.menus;
          this.menues = this.respuesta;
        }

        );
      } else {
        console.error('Token no encontrado en localStorage');
      }
    });
  }
}

