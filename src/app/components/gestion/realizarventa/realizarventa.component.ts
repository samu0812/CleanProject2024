import { AlertasService } from '../../../services/alertas/alertas.service';
import { ImagenService } from '../../../services/imagen/imagen.service';
import { Menu } from './../../../models/menu/menu';
import { TipoCategoria } from './../../../models/parametria/tipoCategoria';
import { TipoCategoriaService } from './../../../services/parametria/tipocategoria.service';
import { Component, OnInit, Input, TemplateRef } from '@angular/core';
import { NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, FormGroup, Validators, FormControl } from '@angular/forms';
import { NgIfContext } from '@angular/common';
import { SnackbarService } from '../../../services/snackbar/snackbar.service';
@Component({
  selector: 'app-realizarventa',
  templateUrl: './realizarventa.component.html',
  styleUrl: './realizarventa.component.css'
})
export class RealizarventaComponent {
  @Input() menu: Menu;
  tituloModal: string;
  tituloBoton: string;
  itemGrilla: TipoCategoria;
  listaGrilla: TipoCategoria[];
  modalRef: NgbModalRef;
  formItemGrilla: FormGroup;
  formFiltro: FormGroup;
  Token: string;
  imgSubmenu: Menu;
  paginaActual = 1;
  elementosPorPagina = 10;
  loading: boolean = true;
  Busqueda = "";
  noData: TemplateRef<NgIfContext<boolean>>;
  showToast: boolean = false;
  toastTimeout: any;

  constructor(
    private tipoCategoriaService: TipoCategoriaService,
    private formBuilder: FormBuilder,
    private imagenService: ImagenService,
    private alertasService: AlertasService,
    private snackbarService: SnackbarService
  ) {}

  ngOnInit(): void {
    this.obtenerImgMenu();
    this.Token = localStorage.getItem('Token');
    this.formItemGrilla = this.formBuilder.group({
      descripcion: new FormControl('', [Validators.required])
    });

    this.formFiltro = this.formBuilder.group({
      idFiltro: new FormControl('1', [Validators.required]),
      busqueda: new FormControl('') // Control de búsqueda
    });

    this.listar(1);

    this.formFiltro.get('idFiltro').valueChanges.subscribe(value => {
      this.listar(value);
    });

    this.formFiltro.get('busqueda').valueChanges.subscribe(value => {
      this.Busqueda = value;
    });
  }

  obtenerImgMenu() {
    this.imagenService.getImagenSubMenu('/gestion/realizarventa').subscribe(data => {
      this.imgSubmenu = data.ImagenSubmenu[0];
    });
  }

  listar(TipoLista: number): void {
    this.loading = true;
    this.tipoCategoriaService.listar(TipoLista).subscribe(
      response => {
        this.itemGrilla = new TipoCategoria();
        this.listaGrilla = response.TipoCategoria || [];
        this.loading = false;
      },
      error => {
        this.alertasService.ErrorAlert('Error', error.error.message);
        this.loading = false;
      }
    );
  }

  cambiarFiltro(): void {
    const filtro = this.formFiltro.get('idFiltro').value;
    this.listar(filtro);
  }

  generarVenta(): void {
    const snackbarRef = this.snackbarService.openSnackbar('Generando venta...', '', 60000);

    snackbarRef.afterDismissed().subscribe(() => {
      console.log('Snackbar cerrado');
    });
  }


  cancelarVenta(): void {
    this.snackbarService.openSnackbar('Venta cancelada', '', 3000);
    console.log('Hola');
  }

}
