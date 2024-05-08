import { ComponentFixture, TestBed } from '@angular/core/testing';

import { InformesfinancierosComponent } from './informesfinancieros.component';

describe('InformesfinancierosComponent', () => {
  let component: InformesfinancierosComponent;
  let fixture: ComponentFixture<InformesfinancierosComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [InformesfinancierosComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(InformesfinancierosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
