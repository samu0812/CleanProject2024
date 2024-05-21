import { TestBed } from '@angular/core/testing';

import { TiporolService } from './tiporol.service';

describe('TiporolService', () => {
  let service: TiporolService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(TiporolService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
