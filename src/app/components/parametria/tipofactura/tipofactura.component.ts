import { Component } from '@angular/core';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, FormGroup, Validators, FormControl } from '@angular/forms';
import { TipoFacturas } from '../../../models/parametria/tipofactura';
import { TipofacturaService } from '../../../services/parametria/tipofactura.service';
import { Menu } from '../../../models/menu/menu';
import { ImagenService } from '../../../services/imagen/imagen.service';
import { AlertasService } from '../../../services/alertas/alertas.service';

@Component({
  selector: 'app-tipofactura',
  templateUrl: './tipofactura.component.html',
  styleUrl: './tipofactura.component.css'
})
export class TipofacturaComponent {

  itemGrilla: TipoFacturas; // cada item de la tabla
  listaGrilla: TipoFacturas[] = []; // tabla completa en donde se cargan los datos
  modalRef: NgbModalRef;
  formItemGrilla: FormGroup;
  formFiltro: FormGroup;
  Token: string;
  imgSubmenu: Menu;

  constructor(
    private tipofacturaService: TipofacturaService,
    private modalService: NgbModal,
    private formBuilder: FormBuilder,
    private imagenService: ImagenService,
    private alertasService: AlertasService
  ) {}

  ngOnInit(): void {
    this.obtenerImgMenu()
    this.Token = localStorage.getItem('Token');
    this.formItemGrilla = this.formBuilder.group({
      descripcion: new FormControl('', [Validators.required])
    });

    this.formFiltro = this.formBuilder.group({
      idFiltro: new FormControl('1', [Validators.required]) // Default value set to 1
    });

    this.listar(1); // Initially list only enabled items

    // Listen for changes in the filter and update the list accordingly
    this.formFiltro.get('idFiltro').valueChanges.subscribe(value => {
      this.listar(value);
    });

  }
  obtenerImgMenu(){
    this.imagenService.getImagenSubMenu('/parametria/tipofactura').subscribe(data => {
      this.imgSubmenu = data.ImagenSubmenu[0];
    });
  }


  listar(TipoLista: number): void { // 1 habilitados, 2 inhabilitados y 3 todos
    this.tipofacturaService.listar(TipoLista)
      .subscribe(response => {
        this.listaGrilla = response.TipoFacturas || [];
      }, error => {
        this.alertasService.ErrorAlert('Error', error.error.Message);
      });
  }
}

