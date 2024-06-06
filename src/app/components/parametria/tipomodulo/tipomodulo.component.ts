import { Component } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { AlertasService } from '../../../services/alertas/alertas.service';
import { ImagenService } from '../../../services/imagen/imagen.service';
import { Menu } from '../../../models/menu/menu';
import { TipoModulo } from '../../../models/parametria/tipoModulo';
import { TipomoduloService } from '../../../services/parametria/tipomodulo.service';

@Component({
  selector: 'app-tipomodulo',
  templateUrl: './tipomodulo.component.html',
  styleUrls: ['./tipomodulo.component.css']
})
export class TipomoduloComponent {
  itemGrilla: TipoModulo; // cada item de la tabla
  listaGrilla: TipoModulo[] = []; // tabla completa en donde se cargan los datos
  modalRef: NgbModalRef;
  formItemGrilla: FormGroup;
  formFiltro: FormGroup;
  Token: string;
  imgSubmenu: Menu;
  paginaActual = 1; // Página actual
  elementosPorPagina = 10; // Elementos por página
  loading: boolean = true;

  constructor(
    private tipomoduloService: TipomoduloService,
    private modalService: NgbModal,
    private formBuilder: FormBuilder,
    private imagenService: ImagenService,
    private alertasService: AlertasService
  ) {}

  ngOnInit(): void {
    this.obtenerImgMenu();
    this.Token = localStorage.getItem('Token');
    this.formItemGrilla = this.formBuilder.group({
      descripcion: new FormControl('', [Validators.required])
    });

    this.formFiltro = this.formBuilder.group({
      idFiltro: new FormControl('1', [Validators.required]) 
    });

    this.listar(1);
    this.formFiltro.get('idFiltro').valueChanges.subscribe(value => {
      this.listar(value);
    });
  }

  obtenerImgMenu(): void {
    this.imagenService.getImagenSubMenu('/parametria/tipomodulo').subscribe(data => {
      this.imgSubmenu = data.ImagenSubmenu[0];
    });
  }

  listar(TipoLista: number): void { // 1 habilitados, 2 inhabilitados y 3 todos
    this.loading = true;
    this.tipomoduloService.listar(TipoLista)
      .subscribe(response => {
        this.listaGrilla = response.TipoModulos || [];
        this.loading = false;
      }, error => {
        this.alertasService.ErrorAlert('Error', error.error.Message);
        this.loading = false;
      });
  }

  cambiarPagina(event): void {
    this.paginaActual = event;
  }

}
