import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { DashboardComponent } from './dashboard.component';
import { FacturacionComponent } from './facturacion/facturacion.component';
import { ClientesComponent } from './clientes/clientes.component';
import { ProductosComponent } from './productos/productos.component';
import { VentasComponent } from './ventas/ventas.component';
import { TrabajadorComponent } from './trabajador/trabajador.component';
import { AdministracionComponent } from './administracion/administracion.component';
import { EmpresaComponent } from './empresa/empresa.component';

const routes: Routes = [
  {path:'',component: DashboardComponent,children:[
    {path:'', component: FacturacionComponent},
    {path:'clientes',component: ClientesComponent},
    {path:'productos',component: ProductosComponent},
    {path:'ventas',component: VentasComponent},
    {path:'trabajador',component: TrabajadorComponent},
    {path:'administracion',component: AdministracionComponent},
    {path:'empresa',component: EmpresaComponent},

  ]}

];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class DashboardRoutingModule { }
