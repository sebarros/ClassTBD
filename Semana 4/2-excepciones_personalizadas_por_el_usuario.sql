SELECT * FROM EVENTO;

-- ACTUALIZAR EL ESTADO CANCELADO
UPDATE EVENTO SET ESTADO = 'CANCELADO' WHERE EVENTO_ID = 1;
COMMIT;

DECLARE
    e_evento_cancelado EXCEPTION;
    v_estado EVENTO.estado%TYPE;
BEGIN
    SELECT estado INTO v_estado
    FROM EVENTO
    WHERE nombre = 'Bad Bunny - World''s Hottest Tour';

    IF v_estado = 'CANCELADO' THEN
        RAISE e_evento_cancelado;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Evento disponible para venta.');
EXCEPTION
    WHEN e_evento_cancelado THEN
        DBMS_OUTPUT.PUT_LINE('No se puede vender: el evento está cancelado.');
END;

DECLARE
    e_evento_no_en_venta EXCEPTION;
    v_estado EVENTO.estado%TYPE;
    v_stock  LOCALIDAD_EVENTO.stock_disponible%TYPE;
BEGIN
    -- 1. Verificar estado del evento
    SELECT estado INTO v_estado
    FROM EVENTO WHERE evento_id = 1;

    IF v_estado != 'VENTA' THEN
        RAISE e_evento_no_en_venta;
    END IF;

    -- 2. Verificar stock
    SELECT stock_disponible INTO v_stock
    FROM LOCALIDAD_EVENTO WHERE localidad_evento_id = 1;

    IF v_stock <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Entradas agotadas.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('Reserva posible. Stock: ' || v_stock);
EXCEPTION
    WHEN e_evento_no_en_venta THEN
        DBMS_OUTPUT.PUT_LINE('El evento no está en venta (estado: ' || v_estado || ').');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Evento o localidad no encontrada.');
END;

DECLARE
    v_stock LOCALIDAD_EVENTO.stock_disponible%TYPE;
BEGIN
    SELECT stock_disponible INTO v_stock
    FROM LOCALIDAD_EVENTO
    WHERE localidad_evento_id = 1;

    IF v_stock <= 0 THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Sin stock: las entradas para esta localidad están agotadas.'
        );
    END IF;

    DBMS_OUTPUT.PUT_LINE('Stock disponible: ' || v_stock);
END;

1. **Respuesta:** **b)** Una FUNCTION siempre retorna exactamente un valor con RETURN y puede usarse directamente dentro de una sentencia SELECT (si no realiza DML), mientras que un PROCEDURE ejecuta acciones y no retorna un valor directamente.


2. **Respuesta:** **c)** Comienza siempre en NULL dentro del procedimiento, ignorando cualquier valor previo del invocante.


3. **Respuesta:** **b)** PLS-00363: expression cannot be used as an assignment target, porque los parÃ¡metros IN actÃºan como constantes de solo lectura.


4. **Respuesta:** **b)** Cuando se requiere modificar o limpiar los valores del pseudo-registro :NEW antes de que la fila se escriba definitivamente en disco.


5. **Respuesta:** **a)** :OLD contiene los datos de la fila que se estÃ¡ eliminando y :NEW es NULL.


6. **Respuesta:** **b)** WHEN (OLD.precio != NEW.precio) â€” sin dos puntos (:)


7. **Respuesta:** **c)** Primero la EspecificaciÃ³n (declara la interfaz pÃºblica) y luego el Cuerpo (implementa el cÃ³digo); si cambia el cuerpo, no se requiere recompilar los programas clientes.


8. **Respuesta:** **c)** Reside en la memoria de la sesiÃ³n (PGA) del usuario conectado y mantiene su valor durante toda su conexiÃ³n.



---

### **2. Preguntas de SelecciÃ³n MÃºltiple**

9. **Respuestas correctas:**
* **a)** Si una funciÃ³n incluye sentencias DML (INSERT/UPDATE/DELETE), no podrÃ¡ ser ejecutada dentro de una consulta SELECT simple (error ORA-14551).


* **b)** Si el flujo de ejecuciÃ³n de una funciÃ³n alcanza el END sin toparse con una sentencia RETURN, Oracle arroja en tiempo de ejecuciÃ³n el error ORA-06503.


* **c)** Aunque Oracle permite compilar funciones con parÃ¡metros OUT, se considera una mala prÃ¡ctica porque inhabilita su uso directo en sentencias SELECT.




10. **Respuestas correctas:**
* **a)** La clÃ¡usula DEFAULT solo actÃºa si la columna viene vacÃ­a (NULL); si el usuario envÃ­a un texto con mayÃºsculas y espacios desordenados, DEFAULT no hace nada.


* **b)** Una CHECK CONSTRAINT se limita a rechazar la fila con un mensaje de error y botar la compra, en lugar de corregir o normalizar el dato automÃ¡ticamente en el aire.


* **c)** Un procedimiento almacenado funciona bien solo si todos lo usan, pero puede ser evadido por completo si un administrador o script batch ejecuta un INSERT directo en la base de datos.




11. **Respuestas correctas:**
* **a)** Un trigger Statement-Level (sin FOR EACH ROW) se ejecuta una Ãºnica vez por instrucciÃ³n DML, sin importar si la sentencia afectÃ³ 0, 1 o 10.000 filas.


* **b)** Solo los triggers FOR EACH ROW tienen acceso a los pseudo-registros :OLD y :NEW.


* **d)** Si un UPDATE actualiza 50 localidades, un trigger AFTER UPDATE ... FOR EACH ROW se ejecutarÃ¡ exactamente 50 veces.




12. **Respuestas correctas:**
* **a)** OrganizaciÃ³n y encapsulamiento: agrupa objetos lÃ³gicamente relacionados en un Ãºnico contenedor ordenado.


* **b)** ReutilizaciÃ³n interna: un procedimiento dentro del cuerpo puede invocar directamente funciones del mismo paquete sin prefijos adicionales.


* **c)** Estado persistente de sesiÃ³n: permite almacenar variables compartidas que mantienen su valor mientras dure la conexiÃ³n del cliente.





---

### **3. TÃ©rminos Pareados**

* **ParÃ¡metro IN OUT:** Permite leer el valor entrante del invocante y a la vez devolverlo modificado al finalizar la ejecuciÃ³n.


* **Pseudo-registro :OLD:** Contiene la fotografÃ­a del registro antes de la modificaciÃ³n; en sentencias INSERT su valor es NULL.


* **Timing BEFORE:** Momento de disparo ideal para interceptar, validar o normalizar valores en :NEW antes de tocar el disco.


* **Timing AFTER:** Momento de disparo ideal para auditorÃ­as y bitÃ¡coras de cambios ya consumados en tablas secundarias.


* **EspecificaciÃ³n del Paquete:** ActÃºa como la "carta del menÃº": declara pÃºblicamente los nombres de variables, funciones y procedimientos disponibles.


* **RAISE_APPLICATION_ERROR:** Procedimiento de Oracle para emitir excepciones personalizadas con cÃ³digos numÃ©ricos obligatorios entre -20000 y -20999.



---

### **4. Verdadero o Falso con JustificaciÃ³n**

14. **Respuesta:** **Falso**

* **JustificaciÃ³n:** Los parÃ¡metros de tipo OUT requieren pasar una variable del bloque invocante para almacenar el valor retornado. Pasar un valor literal directo lanza un error de compilaciÃ³n (PLS-00363) porque un literal no puede modificar su contenido.




15. **Respuesta:** **Falso**

* **JustificaciÃ³n:** Una funciÃ³n invocada desde una sentencia SELECT no puede realizar operaciones DML (INSERT, UPDATE, DELETE) a menos que estÃ© configurada como transacciÃ³n autÃ³noma (`PRAGMA AUTONOMOUS_TRANSACTION`). De lo contrario, Oracle arroja el error `ORA-14551`.




16. **Respuesta:** **Falso**

* **JustificaciÃ³n:** Los valores del pseudo-registro `:NEW` solo pueden ser modificados dentro de triggers con timing **BEFORE**. En un trigger **AFTER**, la fila ya ha sido escrita en la tabla, por lo que los valores de `:NEW` son de solo lectura y provocan un error de compilaciÃ³n.




17. **Respuesta:** **Verdadero**

* **JustificaciÃ³n:** La especificaciÃ³n declara los componentes pÃºblicos e interfaz del paquete, los cuales son necesarios para verificar los tipos de datos y dependencias antes de compilar el cuerpo que los implementa.




18. **Respuesta:** **Falso**

* **JustificaciÃ³n:** Los triggers en Oracle son objetos automÃ¡ticos que se disparan Ãºnicamente ante eventos DML/DDL configurados en la base de datos. No se pueden invocar manualmente ni ejecutar directamente mediante Ã³rdenes de tipo `EXECUTE`.




19. **Respuesta:** **Falso**

* **JustificaciÃ³n:** Las variables de paquete residen en la memoria privada de la sesiÃ³n (`PGA`). Por lo tanto, los cambios realizados por un usuario solo son visibles para su propia sesiÃ³n y no afectan ni se comparten con las sesiones de otros usuarios.

IN NUMBER
RETURN NUMBER
INTO
RETURN v_descuento
RETURN 0

IN NUMBER
OUT VARCHAR2
AS
p_nombre_localidad
RAISE_APPLICATION_ERROR

BEFORE INSERT OR UPDATE
FOR EACH ROW
:NEW.email
INITCAP
INITCAP

AFTER UPDATE
OLD.precio <> NEW.precio
:OLD.precio
:NEW.precio

CREATE OR REPLACE PACKAGE
v_total_vendido
RETURN NUMBER

PACKAGE BODY
consultar_stock
v_total_vendido
v_total_vendido

SoluciÃ³n tÃ©cnica para Punto Ticket mediante PL/SQL
Para solucionar los problemas de Punto Ticket, utilizarÃ­a funciones, procedimientos almacenados, triggers y paquetes de PL/SQL, con el objetivo de mejorar la seguridad, integridad y eficiencia de la base de datos.

1. Funciones: CrearÃ­a consultar_stock, que recibirÃ­a el ID de una localidad y retornarÃ­a las entradas disponibles. TambiÃ©n implementarÃ­a calcular_descuento. Estas funciones podrÃ­an utilizarse en sentencias SELECT para generar reportes. Para evitar el error ORA-14551, no ejecutarÃ­an operaciones DML, como INSERT, UPDATE o DELETE.

2. Procedimientos almacenados: ImplementarÃ­a procesar_compra y cancelar_reserva, utilizando parÃ¡metros IN para recibir datos y OUT para devolver resultados. Al cancelar una reserva, se actualizarÃ­a su estado y se devolverÃ­an las entradas al stock. ControlarÃ­a errores con RAISE_APPLICATION_ERROR, por ejemplo, para indicar stock insuficiente o reservas inexistentes.

3. Triggers: En CLIENTE, crearÃ­a un trigger BEFORE INSERT OR UPDATE FOR EACH ROW para normalizar correos con LOWER(TRIM(:NEW.email)) y nombres con INITCAP. En LOCALIDAD_EVENTO, implementarÃ­a un trigger AFTER UPDATE OF precio FOR EACH ROW para registrar en una tabla de auditorÃ­a el precio anterior (:OLD.precio), el nuevo (:NEW.precio) y la fecha del cambio. UtilizarÃ­a WHEN para registrar Ãºnicamente cambios reales de precio.

4. Paquetes: CrearÃ­a el paquete PKG_BOLETERIA, con una especificaciÃ³n que declare las funciones, procedimientos y variables pÃºblicas, y un cuerpo que implemente la lÃ³gica. Una variable v_total_vendido, inicializada en cero, acumularÃ­a las entradas vendidas durante la sesiÃ³n del cajero, sin registrar cada incremento en una tabla.

ConclusiÃ³n: Estas soluciones permitirÃ­an reducir errores, controlar las ventas y cancelaciones, auditar cambios de precios y mejorar las consultas de stock. AdemÃ¡s, serÃ­a necesario gestionar correctamente las transacciones y la concurrencia para evitar vender mÃ¡s entradas de las disponibles.