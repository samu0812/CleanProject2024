import { TestBed } from '@angular/core/testing';

import { TipodocumentacionService } from './tipodocumentacion.service';

describe('TipodocumentacionService', () => {
  let service: TipodocumentacionService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(TipodocumentacionService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
