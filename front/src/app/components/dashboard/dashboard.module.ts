import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { DashboardRoutingModule } from './dashboard-routing.module';
import { SharedModule } from '../shared/shared.module';
import { DashboardComponent } from './dashboard.component';
import { FacturacionComponent } from './facturacion/facturacion.component';
import { ClientesComponent } from './clientes/clientes.component';
import { ProductosComponent } from './productos/productos.component';
import { NavbarComponent } from './navbar/navbar.component';
import { EmpresaComponent } from './empresa/empresa.component';
import { VentasComponent } from './ventas/ventas.component';
import { TrabajadorComponent } from './trabajador/trabajador.component';
import { AdministracionComponent } from './administracion/administracion.component';
import {MatDialog, MAT_DIALOG_DATA, MatDialogRef, MatDialogModule} from '@angular/material/dialog';

import { FirmaElectronicaComponent } from './firma-electronica/firma-electronica.component';
import { SucursalesComponent } from './sucursales/sucursales.component';
import { MatOptionModule } from '@angular/material/core';
import { MatAutocompleteModule } from '@angular/material/autocomplete';

@NgModule({
  declarations: [
    DashboardComponent,
    FacturacionComponent,
    
    ClientesComponent,
    ProductosComponent,
    NavbarComponent,
    EmpresaComponent,
    VentasComponent,
    TrabajadorComponent,
    AdministracionComponent,
   
    FirmaElectronicaComponent,
    SucursalesComponent,
    
   
  ],
  imports: [
    CommonModule,
    DashboardRoutingModule,
    SharedModule,
    MatDialogModule,
    MatOptionModule,
    MatAutocompleteModule,
    
   
  ]
})
export class DashboardModule { }
