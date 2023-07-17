import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Injectable } from '@angular/core';
import { Trabajador } from '../trabajador.component';
import { map } from 'rxjs/operators';
import { of,throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
@Injectable({
  providedIn: 'root'
})
export class VendedoresService {
  private apiUrl = 'http://127.0.0.1:8000/api/vendedores';

  constructor(private http: HttpClient) { }

  obtenerVendedores(): Observable<any[]> {
    return this.http.get<any[]>(this.apiUrl);
  }

  guardarVendedor(vendedor: Trabajador): Observable<any> {

    const datosEnviar = {

    Nombre: vendedor.nombre,
    Apellido: vendedor.apellido,
    Usuario: vendedor.usuario,
    Contrasenia: vendedor.contrasena,
    CorreoElectronico: vendedor.correoElectronico
    };
    return this.http.post(this.apiUrl, datosEnviar);
  }

  actualizarVendedor(id: number, vendedor: any): Observable<any> {
    const datosEnviar = {
      Nombre: vendedor.nombre,
      Apellido: vendedor.apellido,
      Usuario: vendedor.usuario,
      Contrasenia: vendedor.contrasena,
      CorreoElectronico: vendedor.correoElectronico
    };
    const url = `${this.apiUrl}/${id}`;
    return this.http.put(url, datosEnviar);
  }

  eliminarVendedor(id: number): Observable<any> {
    const url = `${this.apiUrl}/${id}`;
    return this.http.delete(url).pipe(
      catchError((error: any) => {
        console.error(error);
        return throwError('Error al eliminar el vendedor.');
      })
    );
  }

}
