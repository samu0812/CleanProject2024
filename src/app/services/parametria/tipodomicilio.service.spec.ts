import { TestBed } from '@angular/core/testing';

import { TipodomicilioService } from './tipodomicilio.service';

describe('TipodomicilioService', () => {
  let service: TipodomicilioService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(TipodomicilioService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
