import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { Observable } from 'rxjs';
import { map, startWith } from 'rxjs/operators';
import { EstablecimientoService } from './services/venta.service';
import { Trabajador, TrabajadorService } from './services/trabajador.service';

export interface Ventas {
  cantidad: string;
  descripcion: string;
  precioU: string;
  tarifa: string;
  descuento: string;
  valorT: string;
}

export interface Persona {
  identificacion: string;
  tipoIdentificacion: string;
  nombre: string;
  apellido: string;
  direccion: string;
  telefono: string;
  celular: string;
  correoElectronico: string;
}

@Component({
  selector: 'app-ventas',
  templateUrl: './ventas.component.html',
  styleUrls: ['./ventas.component.scss']
})
export class VentasComponent implements OnInit {
  establecimientos: string[] = [];
  trabajadores: string[] = [];
  selectedEstablecimiento: string | undefined;
  myControl = new FormControl<string | Persona>('');
  options: Persona[] = [];
  filteredOptions: Observable<Persona[]> | undefined;
  selectedCliente: Persona | undefined;
  formulario!: FormGroup;
  mostrarFormulario = false;
  data: Ventas[] = [];
  columnas: string[] = ['cantidad', 'descripcion', 'precioU', 'tarifa', 'descuento', 'valorT', 'acciones'];

  constructor(
    private formBuilder: FormBuilder,
    private establecimientoService: EstablecimientoService,
    private trabajadorService: TrabajadorService
  ) {}

  ngOnInit(): void {
    this.formulario = this.formBuilder.group({
      identificacion: ['', Validators.required],
      tipoIdentificacion: ['', Validators.required],
      nombre: ['', Validators.required],
      apellido: ['', Validators.required],
      direccion: ['', Validators.required],
      telefono: ['', Validators.required],
      celular: ['', Validators.required],
      correoElectronico: ['', [Validators.required, Validators.email]],
    });
    this.obtenerEstablecimientos();
    this.obtenerTrabajadores();
    //this.buscarClientes("");
    this.filteredOptions = this.myControl.valueChanges.pipe(
      startWith(''),
      map(value => {
        const identificacion = typeof value === 'string' ? value : value?.identificacion;
        return identificacion ? this._filter(identificacion as string) : this.options.slice();
      }),
    );
  }

  displayFn(persona: Persona): string {
    return persona && persona.identificacion ? persona.identificacion : '';
  }

  private _filter(identificacion: string): Persona[] {
    const filterValue = identificacion.toLowerCase();

    return this.options.filter(option => option.identificacion.toLowerCase().includes(filterValue));
  }

  toggleForm() {
    this.mostrarFormulario = !this.mostrarFormulario;
  }

  selectOption(option: Persona) {
    this.selectedCliente = option;
    this.myControl.setValue(option);
  }

  submitForm() {
    if (this.formulario.valid) {
      const nuevoCliente: Persona = {
        identificacion: this.formulario.value.identificacion,
        tipoIdentificacion: this.formulario.value.tipoIdentificacion,
        nombre: this.formulario.value.nombre,
        apellido: this.formulario.value.apellido,
        direccion: this.formulario.value.direccion,
        telefono: this.formulario.value.telefono,
        celular: this.formulario.value.celular,
        correoElectronico: this.formulario.value.correoElectronico,
      };
      // Aquí puedes hacer lo que necesites con el nuevo cliente, como agregarlo a una lista
      console.log(nuevoCliente);
      this.formulario.reset();
      this.mostrarFormulario = false;
    }
  }

  editarElemento(elemento: Ventas) {
    // Lógica para editar el elemento
  }

  eliminarElemento(elemento: Ventas) {
    // Lógica para eliminar el elemento
  }

  obtenerEstablecimientos(): void {
    this.establecimientoService.obtenerEstablecimientos().subscribe(
      (response: any) => {
        this.establecimientos = response.map((establecimiento: any) => establecimiento.NombreComercial);
      },
      (error: any) => {
        console.error(error);
      }
    );
  }

  obtenerTrabajadores(): void {
    this.trabajadorService.obtenerTrabajadores().subscribe(
      (response: any) => {
        this.options = response.map((trabajador: any) => ({
          nombre: trabajador.Nombre,
          apellido: trabajador.Apellido
        }));
      },
      (error: any) => {
        console.error(error);
      }
    );
  }

  buscarClientes(busqueda: string): void {
    this.establecimientoService.buscarClientes(busqueda).subscribe(
      (response: any) => {
        this.options = response.map((cliente: any) => ({
          identificacion: cliente.Identificacion,
          tipoIdentificacion: cliente.IdTipoIdentificacion,
          nombre: cliente.RazonSocial,
          apellido: cliente.NombreComercial,
          direccion: cliente.Direccion,
          telefono: cliente.Telefono,
          celular: cliente.Celular,
          correoElectronico: cliente.Correo
        }));
        this.filteredOptions = this.myControl.valueChanges.pipe(
          startWith(''),
          map(value => {
            const identificacion = typeof value === 'string' ? value : value?.identificacion;
            return identificacion ? this._filter(identificacion as string) : this.options.slice();
          }),
        );
      },
      (error: any) => {
        console.error(error);
      }
    );
  }

}
