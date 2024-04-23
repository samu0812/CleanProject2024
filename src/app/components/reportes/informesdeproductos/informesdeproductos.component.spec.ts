import { ComponentFixture, TestBed } from '@angular/core/testing';

import { InformesdeproductosComponent } from './informesdeproductos.component';

describe('InformesdeproductosComponent', () => {
  let component: InformesdeproductosComponent;
  let fixture: ComponentFixture<InformesdeproductosComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [InformesdeproductosComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(InformesdeproductosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
