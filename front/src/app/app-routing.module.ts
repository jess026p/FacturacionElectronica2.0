import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LoginComponent } from './components/login/login.component';
import { PrincipalDashComponent } from './principal-dash/principal-dash.component';
import { ClientesComponent } from './principal-dash/clientes/clientes.component';
import { VendedoresComponent } from './principal-dash/vendedores/vendedores.component';

const routes: Routes = [
  {path:'',redirectTo:'login',pathMatch:'full'},
 {path:'login',component:LoginComponent},
{path:'principal-dash',component: PrincipalDashComponent},
{path:'clientes',component: ClientesComponent},
{path:'vendedores',component: VendedoresComponent},

];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
