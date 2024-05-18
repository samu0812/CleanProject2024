import { TestBed } from '@angular/core/testing';

import { TipodestinatariofacturaService } from './tipodestinatariofactura.service';

describe('TipodestinatariofacturaService', () => {
  let service: TipodestinatariofacturaService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(TipodestinatariofacturaService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
