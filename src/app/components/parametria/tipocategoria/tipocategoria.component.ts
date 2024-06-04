import { Component, OnInit, Input, TemplateRef } from '@angular/core';
import { TipoCategoriaService } from '../../../services/parametria/tipocategoria.service';
import { TipoCategoria } from '../../../models/parametria/tipoCategoria';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, FormGroup, Validators, FormControl } from '@angular/forms';
import { Menu } from '../../../models/menu/menu';
import { ImagenService } from '../../../services/imagen/imagen.service';
import { AlertasService } from '../../../services/alertas/alertas.service';
import { NgIfContext } from '@angular/common';

@Component({
  selector: 'app-tipocategoria',
  templateUrl: './tipocategoria.component.html',
  styleUrls: ['./tipocategoria.component.css']
})
export class TipocategoriaComponent implements OnInit {
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

  constructor(
    private tipoCategoriaService: TipoCategoriaService,
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
    this.imagenService.getImagenSubMenu('/parametria/tipocategoria').subscribe(data => {
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

  openAgregar(content) {
    this.tituloModal = 'Agregar';
    this.tituloBoton = 'Agregar';
    this.itemGrilla = Object.assign({}, new TipoCategoria());
    this.modalRef = this.modalService.open(content, { size: 'sm', centered: true });
  }

  openEditar(content, item: TipoCategoria) {
    this.tituloModal = 'Editar';
    this.tituloBoton = 'Guardar';
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(content, { size: 'sm', centered: true });
  }

  openInhabilitar(contentInhabilitar, item: TipoCategoria) {
    this.tituloModal = 'Inhabilitar';
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentInhabilitar, { size: 'sm', centered: true });
  }

  openHabilitar(contentHabilitar, item: TipoCategoria) {
    this.tituloModal = 'Habilitar';
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentHabilitar, { size: 'sm', centered: true });
  }

  guardar(): void {
    this.loading = true;
    if (this.itemGrilla.IdTipoCategoria == null) {
      this.tipoCategoriaService.agregar(this.itemGrilla, this.Token).subscribe(
        response => {
          this.loading = false;
          this.listar(1);
          this.modalRef.close();
          this.alertasService.OkAlert('OK', 'Se Agregó Correctamente');
        },
        error => {
          this.alertasService.ErrorAlert('Error', error.error.Message);
          this.loading = false;
        }
      );
    } else {
      this.tipoCategoriaService.editar(this.itemGrilla, this.Token).subscribe(
        response => {
          this.loading = false;
          this.listar(1);
          this.alertasService.OkAlert('OK', 'Se Modificó Correctamente');
          this.modalRef.close();
        },
        error => {
          this.alertasService.ErrorAlert('Error', error.error.Message);
          this.loading = false;
        }
      );
    }
  }

  inhabilitar(): void {
    this.loading = true;
    this.tipoCategoriaService.inhabilitar(this.itemGrilla, this.Token).subscribe(
      response => {
        this.listar(1);
        this.loading = false;
        this.alertasService.OkAlert('OK', 'Se Inhabilitó Correctamente');
        this.modalRef.close();
      },
      response => {
        this.loading = false;
        this.alertasService.ErrorAlert('Error', response.error.Message);
      }
    );
  }

  habilitar(): void {
    this.loading = true;
    this.tipoCategoriaService.habilitar(this.itemGrilla, this.Token).subscribe(
      response => {
        this.listar(2);
        this.loading = false;
        this.alertasService.OkAlert('OK', 'Se Habilitó Correctamente');
        this.modalRef.close();
      },
      error => {
        this.loading = false;
        this.alertasService.ErrorAlert('Error', error.error.Message);
      }
    );
  }
  limpiarBusqueda(): void {
    this.formFiltro.get('busqueda').setValue('');
  }
  cambiarPagina(event): void {
    this.paginaActual = event;
  }
}
