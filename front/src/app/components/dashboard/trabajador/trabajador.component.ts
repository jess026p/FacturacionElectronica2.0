import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { Observable, startWith, map } from 'rxjs';
import { VendedoresService } from './services/trabajador.service';
import { MatSnackBar } from '@angular/material/snack-bar';
export interface Trabajador {
  id:number;
  nombre: string;
  apellido: string;
  usuario: string;
  contrasena: string;
  correoElectronico: string;
}

@Component({
  selector: 'app-trabajador',
  templateUrl: './trabajador.component.html',
  styleUrls: ['./trabajador.component.scss']
})
export class TrabajadorComponent implements OnInit {
  myControl = new FormControl<Trabajador | null>(null);
  options: Trabajador[] = [];
  filteredOptions: Observable<Trabajador[]> | undefined;
  vendedorSeleccionado: Trabajador | null = null;
  data: Trabajador[] = [];
  originalData: Trabajador[] = []; // Guarda los datos originales de la tabla
  columnas: string[] = ['nombre', 'apellido', 'usuario', 'contrasena', 'correoElectronico', 'acciones'];

  formulario!: FormGroup;
  mostrarFormulario = false;

  constructor(private formBuilder: FormBuilder, private vendedoresService: VendedoresService,
    private snackBar: MatSnackBar) {}

  ngOnInit(): void {
    this.formulario = this.formBuilder.group({
      nombre: ['', Validators.required],
      apellido: ['', Validators.required],
      usuario: ['', Validators.required],
      contrasena: ['', Validators.required],
      correoElectronico: ['', [Validators.required, Validators.email]],
    });

    this.obtenerTrabajadores();

    this.filteredOptions = this.myControl.valueChanges.pipe(
      startWith(''),
      map((value: string | Trabajador | null) => {
        const nombre = typeof value === 'string' ? value.toLowerCase() : value?.nombre?.toLowerCase() || '';
        return nombre ? this._filterNombre(nombre) : this.options.slice();
      })
    );


    this.formulario.get('nombre')?.valueChanges.subscribe((value: string) => {
      if (value === '') {
        this.resetTabla();
      }
    });
  }

  obtenerTrabajadores(): void {
    this.vendedoresService.obtenerVendedores().subscribe(
      response => {
        this.originalData = response.map((trabajador: any) => ({
          id: trabajador.Id,  // Asigna el valor del campo 'Id' al campo 'id'
          nombre: trabajador.Nombre,
          apellido: trabajador.Apellido,
          usuario: trabajador.Usuario,
          contrasena: trabajador['Contrasenia'],
          correoElectronico: trabajador.CorreoElectronico
        }));

        this.data = this.originalData.slice();
      },
      error => {
        console.error(error);
      }
    );
  }

  displayFn(trabajador: Trabajador): string {
    return trabajador && trabajador.nombre ? trabajador.nombre : '';
  }

  private _filterNombre(nombre: string): Trabajador[] {
    const filterValue = nombre.toLowerCase();
    return this.options.filter(option => option.nombre.toLowerCase().includes(filterValue));
  }

  editarElemento(elemento: Trabajador) {
    this.vendedorSeleccionado = elemento;
    this.mostrarFormulario = true;
    this.formulario.patchValue(elemento);
  }

  eliminarElemento(elemento: Trabajador) {
    if (elemento.id) { // Verifica si elemento.id tiene un valor
      const confirmarEliminacion = confirm('¿Estás seguro de que deseas eliminar este vendedor?');
      if (confirmarEliminacion) {
        this.vendedoresService.eliminarVendedor(elemento.id).subscribe(
          () => {
            this.data = this.data.filter((item) => item.id !== elemento.id);
            this.snackBar.open('Vendedor eliminado correctamente', 'Cerrar', {
              duration: 3000,
            });
          },
          (error) => {
            console.error('Error al eliminar el vendedor', error);
            this.snackBar.open('Error al eliminar el vendedor', 'Cerrar', {
              duration: 3000,
            });
          }
        );
      }
    }
  }


  toggleForm() {
    this.mostrarFormulario = !this.mostrarFormulario;
  }

  selectOption(option: Trabajador) {
    this.myControl.setValue(option);
  }

  submitForm() {
    if (this.formulario.valid) {
      const formularioValues = this.formulario.value;
      const nuevoVendedor: Trabajador = {
        id: this.vendedorSeleccionado ? this.vendedorSeleccionado.id : 0,
        nombre: this.formulario.value.nombre,
        apellido: this.formulario.value.apellido,
        usuario: this.formulario.value.usuario,
        contrasena: this.formulario.value.contrasena,
        correoElectronico: this.formulario.value.correoElectronico
      };

      if (this.vendedorSeleccionado) {
        // Actualizar el cliente existente
        this.vendedoresService.actualizarVendedor(nuevoVendedor.id,nuevoVendedor).subscribe(
          (response) => {
            console.log('Cliente actualizado exitosamente', response);
            this.obtenerTrabajadores();
            this.formulario.reset();
            this.vendedorSeleccionado = null;
            this.toggleForm();
          },
          (error) => {
            console.error('Error al actualizar el cliente', error);
          }
        );
      } else {
        // Crear un nuevo cliente
        this.vendedoresService.guardarVendedor(nuevoVendedor).subscribe(
          (response) => {
            console.log('Cliente creado exitosamente', response);
            this.obtenerTrabajadores();
            this.formulario.reset();
            this.toggleForm();
          },
          (error) => {
            console.error('Error al crear el cliente', error);
          }
        );
      }
    }
  }



  buscarVendedor() {
    const valorBusqueda = (typeof this.myControl.value === 'string' ? this.myControl.value : this.myControl.value?.nombre) || '';
    const valorBusquedaLowerCase = valorBusqueda.toLowerCase();

    if (valorBusqueda === '') {
      this.data = this.originalData.slice();
    } else {
      this.data = this.originalData.filter(
        trabajador => trabajador.nombre.toLowerCase().includes(valorBusquedaLowerCase) ||
                      trabajador.apellido.toLowerCase().includes(valorBusquedaLowerCase)
      );
    }
  }

  resetTabla() {
    this.data = [...this.originalData];
  }
}
