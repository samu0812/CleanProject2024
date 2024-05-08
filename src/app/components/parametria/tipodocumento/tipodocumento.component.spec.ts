import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TipodocumentoComponent } from './tipodocumento.component';

describe('TipodocumentoComponent', () => {
  let component: TipodocumentoComponent;
  let fixture: ComponentFixture<TipodocumentoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [TipodocumentoComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(TipodocumentoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
