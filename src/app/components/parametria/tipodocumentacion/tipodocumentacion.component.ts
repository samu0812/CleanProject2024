import { Component } from '@angular/core';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, FormGroup, Validators, FormControl } from '@angular/forms';
import { TipoDocumentacion } from '../../../models/parametria/tipodocumentacion';
import { TipodocumentacionService } from '../../../services/parametria/tipodocumentacion.service';

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

  constructor(
    private tipodocumentacionService: TipodocumentacionService,
    private modalService: NgbModal,
    private formBuilder: FormBuilder
  ) {}

  ngOnInit(): void {
    this.Token = localStorage.getItem('Token');
    this.listar(1);
    this.formItemGrilla = this.formBuilder.group({
      descripcion: new FormControl('', [Validators.required])
    });

    this.formFiltro = this.formBuilder.group({
      idFiltro: new FormControl('', [Validators.required])
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
