import { Component, OnInit, Input, ViewChild } from '@angular/core';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, FormGroup, Validators, FormControl, FormArray } from '@angular/forms';
import { Menu } from '../../../models/menu/menu';
import { ImagenService } from '../../../services/imagen/imagen.service';
import { AlertasService } from '../../../services/alertas/alertas.service';
import { TipopermisoService } from '../../../services/parametria/tipopermiso.service';
import { TipoPermiso } from '../../../models/parametria/tipopermiso';
import { TipoPermisoDetalles } from '../../../models/parametria/tipopermisodetalle';


@Component({
  selector: 'app-tipopermiso',
  templateUrl: './tipopermiso.component.html',
  styleUrl: './tipopermiso.component.css'
})
export class TipopermisoComponent {
  tituloModal: string;
  tituloBoton: string;
  itemGrilla: TipoPermiso;
  listaGrilla: TipoPermiso[]; 
  itemGrilla2: TipoPermisoDetalles;
  listaGrilla2: TipoPermisoDetalles[]; 
  modalRef: NgbModalRef;
  formItemGrilla: FormGroup;
  formFiltro: FormGroup;
  Token: string;
  imgSubmenu: Menu;
  modalData: string;
  lTipoPermiso: TipoPermiso[];
  lTipoPermisoDetalles: TipoPermisoDetalles[];
  paginaActual = 1; // Página actual
  elementosPorPagina = 10; // Elementos por página
  loading: boolean = true;


  constructor(private tipopermisoService: TipopermisoService,
    private modalService: NgbModal,
    private formBuilder: FormBuilder,
    private imagenService: ImagenService,
    private alertasService: AlertasService
  ) {}
  
  ngOnInit(): void {
    this.obtenerImgMenu()
    this.listar(); 
    this.listarDetalle(1);
    this.formItemGrilla = this.formBuilder.group({
      Detalle: new FormControl('', [Validators.required])
    });
  }
  obtenerImgMenu(){
    this.imagenService.getImagenSubMenu('/parametria/tipopermiso').subscribe(data => {
      this.imgSubmenu = data.ImagenSubmenu[0];
    });
  }

  listar(): void { // 1 habilitados, 2 inhabilitados y 3 todos
    this.loading = true;
    this.tipopermisoService.listar().subscribe(
      response => {
        this.itemGrilla = new TipoPermiso();
        this.listaGrilla = response.TipoPermiso || [];
        this.loading = false;
      },
      error => {
        this.alertasService.ErrorAlert('Error', error.error.message);
        this.loading = false;
      }
    );
  }
  listarDetalle(TipoLista: number): void { // 1 habilitados, 2 inhabilitados y 3 todos
    this.loading = true;
    this.tipopermisoService.listarDetalle(TipoLista).subscribe(
      response => {
        this.itemGrilla2 = new TipoPermisoDetalles();
        this.listaGrilla2 = response.TipoPermisoDetalles || [];
        this.loading = false;
      },
      error => {
        this.alertasService.ErrorAlert('Error', error.error.message);
        this.loading = false;
      }
    );
  }
  cambiarPagina(event): void {
    this.paginaActual = event;
  }
  openEditar(content, item: TipoPermiso) {
    this.tituloModal = "Editar";
    this.tituloBoton = "Guardar";
    this.itemGrilla = Object.assign({}, item); // Duplica el item para que no cambie por detrás y modifiquemos este para enviar al back
    this.modalRef = this.modalService.open(content, { size: 'sm', centered: true });
  }
  

}
