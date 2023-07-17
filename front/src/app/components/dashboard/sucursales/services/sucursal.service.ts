import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class SucursalService {
  private apiUrl = 'http://127.0.0.1:8000/api/empresas';

  constructor(private http: HttpClient) { }

  obtenerSucursales(): Observable<any[]> {
    return this.http.get<any[]>(this.apiUrl);
  }
  eliminarSucursal(identificacion: string): Observable<any> {
    const url = `${this.apiUrl}/${identificacion}`;
    return this.http.delete<any>(url);
  }

}
