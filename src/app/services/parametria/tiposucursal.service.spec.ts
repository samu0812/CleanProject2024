import { TestBed } from '@angular/core/testing';

import { TiposucursalService } from './tiposucursal.service';

describe('TiposucursalService', () => {
  let service: TiposucursalService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(TiposucursalService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
