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
  Menues: Menu[] = [];
  respuesta: Menu[] = [];

  constructor(private route: ActivatedRoute, private menuService: MenuService) {}

  ngOnInit(): void {
    this.route.params.subscribe(params => {
      const IdMenu = +params['id'];
      const Token = localStorage.getItem('Token');
      if (Token !== null) {
        this.menuService.getSubMenuItems(Token, IdMenu).subscribe( data=>{
          console.log(data.Menus , 'menuessssss');
          this.respuesta = data.Menus;
          this.Menues = this.respuesta;
          this.Menues.forEach(menu => {
            console.log(menu.PoseePermiso);
          });
        }

        );
      } else {
        console.error('Token no encontrado en localStorage');
      }
    });
  }
}

