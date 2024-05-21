import { Component, OnInit } from '@angular/core';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, FormGroup, Validators, FormControl } from '@angular/forms';
import { TipoPersonas } from '../../../models/parametria/tipopersona';
import { TipopersonaService } from '../../../services/parametria/tipopersona.service';
import { Menu } from '../../../models/menu/menu';
import { ImagenService } from '../../../services/imagen/imagen.service';

@Component({
  selector: 'app-tipopersona',
  templateUrl: './tipopersona.component.html',
  styleUrl: './tipopersona.component.css'
})
export class TipopersonaComponent {
  itemGrilla: TipoPersonas; // cada item de la tabla
  listaGrilla: TipoPersonas[] = []; // tabla completa en donde se cargan los datos
  modalRef: NgbModalRef;
  formItemGrilla: FormGroup;
  formFiltro: FormGroup;
  Token: string;
  imgSubmenu: Menu;

  constructor(
    private tipopersonaService: TipopersonaService,
    private modalService: NgbModal,
    private formBuilder: FormBuilder,
    private imagenService: ImagenService
  ) {}

  ngOnInit(): void {
    this.obtenerImgMenu()
    this.Token = localStorage.getItem('Token');
    this.listar(1);
    this.formItemGrilla = this.formBuilder.group({
      descripcion: new FormControl('', [Validators.required])
    });

    this.formFiltro = this.formBuilder.group({
      idFiltro: new FormControl('', [Validators.required])
    });
  }
  obtenerImgMenu(){
    this.imagenService.getImagenSubMenu('/parametria/tipopersona').subscribe(data => {
      this.imgSubmenu = data.ImagenSubmenu[0];
      console.log(data);
      console.log(data.ImagenSubmenu[0]);
    });
  }

  listar(TipoLista: number): void { // 1 habilitados, 2 inhabilitados y 3 todos
    this.tipopersonaService.listar(TipoLista)
      .subscribe(response => {
        this.listaGrilla = response.TipoPersonas || [];
      }, error => {
        console.error('Error al cargar tipos de categoría:', error);
      });
  }
}