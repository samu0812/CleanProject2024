import { TestBed } from '@angular/core/testing';

import { TipoimpuestoService } from './tipoimpuesto.service';

describe('TipoimpuestoService', () => {
  let service: TipoimpuestoService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(TipoimpuestoService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
