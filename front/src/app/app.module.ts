import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatButtonModule } from '@angular/material/button';
import { MatSidenavModule } from '@angular/material/sidenav';
import { NavegacionComponent } from './navegacion/navegacion.component';
import { LoginComponent } from './components/login/login.component';
import { ClientesComponent } from './principal-dash/clientes/clientes.component';
import { VentasComponent } from './principal-dash/ventas/ventas.component';
import { EmpresaComponent } from './principal-dash/empresa/empresa.component';
import { VendedoresComponent } from './principal-dash/vendedores/vendedores.component';
import { ProductosComponent } from './principal-dash/productos/productos.component';
import { SharedModule } from './components/shared/shared.module';

@NgModule({
  declarations: [
    AppComponent,
    NavegacionComponent,
    LoginComponent,
    ClientesComponent,
    VentasComponent,
    EmpresaComponent,
    VendedoresComponent,
  ProductosComponent,
 
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    MatToolbarModule,
    MatButtonModule,
    MatSidenavModule,
    SharedModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
