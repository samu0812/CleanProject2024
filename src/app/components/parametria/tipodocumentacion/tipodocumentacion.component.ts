import { Component } from '@angular/core';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, FormGroup, Validators, FormControl } from '@angular/forms';
import { TipoDocumentacion } from '../../../models/parametria/tipodocumentacion';
import { TipodocumentacionService } from '../../../services/parametria/tipodocumentacion.service';
import { Menu } from '../../../models/menu/menu';
import { ImagenService } from '../../../services/imagen/imagen.service';

@Component({
  selector: 'app-tipodocumentacion',
  templateUrl: './tipodocumentacion.component.html',
  styleUrl: './tipodocumentacion.component.css'
})
export class TipodocumentacionComponent {

  itemGrilla: TipoDocumentacion; // cada item de la tabla
  listaGrilla: TipoDocumentacion[] = []; // tabla completa en donde se cargan los datos
  modalRef: NgbModalRef;
  formItemGrilla: FormGroup;
  formFiltro: FormGroup;
  Token: string;
  imgSubmenu: Menu;

  constructor(
    private tipodocumentacionService: TipodocumentacionService,
    private modalService: NgbModal,
    private formBuilder: FormBuilder,
    private imagenService: ImagenService
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
    this.imagenService.getImagenSubMenu('/parametria/tipodocumentacion').subscribe(data => {
      this.imgSubmenu = data.ImagenSubmenu[0];
    });
  }

  listar(TipoLista: number): void { // 1 habilitados, 2 inhabilitados y 3 todos
    this.tipodocumentacionService.listar(TipoLista)
      .subscribe(response => {
        this.listaGrilla = response.TipoDocumentacion || [];
      }, error => {
        console.error('Error al cargar tipos de categoría:', error);
      });
  }
}
