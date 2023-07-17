import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FirmaElectronicaComponent } from './firma-electronica.component';

describe('FirmaElectronicaComponent', () => {
  let component: FirmaElectronicaComponent;
  let fixture: ComponentFixture<FirmaElectronicaComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [FirmaElectronicaComponent]
    });
    fixture = TestBed.createComponent(FirmaElectronicaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
