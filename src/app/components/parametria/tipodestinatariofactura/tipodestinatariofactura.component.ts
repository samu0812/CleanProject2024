import { Component, OnInit } from '@angular/core';
import { TipodestinatariofacturaService } from '../../../services/parametria/tipodestinatariofactura.service';
import { TipoDestinatarioFacturas } from '../../../models/parametria/tipodestinatariofactura';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, FormGroup, Validators, FormControl } from '@angular/forms';
import { Menu } from '../../../models/menu/menu';
import { ImagenService } from '../../../services/imagen/imagen.service';

@Component({
  selector: 'app-tipodestinatariofactura',
  templateUrl: './tipodestinatariofactura.component.html',
  styleUrls: ['./tipodestinatariofactura.component.css']
})
export class TipodestinatariofacturaComponent implements OnInit {

  itemGrilla: TipoDestinatarioFacturas; // cada item de la tabla
  listaGrilla: TipoDestinatarioFacturas[] = []; // tabla completa en donde se cargan los datos
  modalRef: NgbModalRef;
  formItemGrilla: FormGroup;
  formFiltro: FormGroup;
  Token: string;
  imgSubmenu: Menu;

  constructor(
    private tipodestinatariofacturaService: TipodestinatariofacturaService,
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
    this.imagenService.getImagenSubMenu('/parametria/tipodestinatariofactura').subscribe(data => {
      this.imgSubmenu = data.ImagenSubmenu[0];
    });
  }

  listar(TipoLista: number): void { // 1 habilitados, 2 inhabilitados y 3 todos
    this.tipodestinatariofacturaService.listar(TipoLista)
      .subscribe(response => {
        this.listaGrilla = response.TipoDestinatarioFacturas || [];
      }, error => {
        console.error('Error al cargar tipos de categoría:', error);
      });
  }
}
