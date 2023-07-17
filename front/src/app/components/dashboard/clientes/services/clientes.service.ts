import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';


@Injectable({
  providedIn: 'root'
})
export class ClientesService {
  private apiUrl = 'http://127.0.0.1:8000/api/personas';

  constructor(private http: HttpClient) { }

  obtenerClientes(): Observable<any> {
    return this.http.get(this.apiUrl);
  }

  crearCliente(cliente: any): Observable<any> {

    const datosEnviar = {
      Identificacion: cliente.identificacion,
      // Completar los demás campos con datos quemados
      RazonSocial: cliente.nombre,
      NombreComercial: cliente.apellido,
      Correo: cliente.correoElectronico,
      Direccion: cliente.direccion,
      Telefono: cliente.telefono,
      Celular: cliente.celular,
      IdRolPersona: 1,
      Rol: "Cliente",
      AgenteRetencion: 0,
      Microempresa: 0,
      TipoRegimen: "RG",
      CodigoReferencia: null,
      InfoAdicional: null,
      IdProvincia: 1,
      IdCiudad: 88,
      IdTipoIdentificacion: 1,
      IdEmpresa: 1,
      IdTipoContribuyente: 1,
      IdCuenta: 1,
      IdConceptoRetencionFuente: 1,
      IdConceptoRetencionIva: null,
      IdCuentaGasto: null,
      IdCuentaIva: null,
      IdVendedor: 1,
      IdGrupoPersona: 1,
      ParteRelacional: "NO",
      IdTipoPago: null,
      CodigoTipoPago: null,
      Activo: 1,
      FechaInicio: null,
      FechaFin: null,
      Membresia: 0,
      Periocidad: "Personalizada",
      Periodo: 0,
      LimiteCredito: "0.00",
      FechaCreacion: "2023-07-12 18:47:45"
    };
    return this.http.post(this.apiUrl, datosEnviar);
  }

  actualizarCliente(id: number, cliente: any): Observable<any> {
    const datosEnviar = {
      Identificacion: cliente.identificacion,
      // Completar los demás campos con datos quemados
      RazonSocial: cliente.nombre,
      NombreComercial: cliente.apellido,
      Correo: cliente.correoElectronico,
      Direccion: cliente.direccion,
      Telefono: cliente.telefono,
      Celular: cliente.celular
    };
    const url = `${this.apiUrl}/${id}`;
    return this.http.put(url, datosEnviar);
  }

  eliminarCliente(id: number): Observable<any> {
    const url = `${this.apiUrl}/${id}`;
    return this.http.delete(url);
  }


}
