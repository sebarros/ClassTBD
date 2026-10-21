SELECT EMAIL FROM CLIENTE where RUT = '11.111.111-1';
SELECT EMAIL FROM CLIENTE;

--No data found
DECLARE 
    v_email CLIENTE.EMAIL%TYPE;
BEGIN 
    SELECT EMAIL INTO v_email FROM CLIENTE where RUT = '11.111.111-1';
    DBMS_OUTPUT.PUT_LINE('El email es: ' || v_email);

EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No existe datos para el cliente que intenta consultar');
END;
/


SELECT EMAIL FROM CLIENTE where RUT = '11.111.111-1';
SELECT EMAIL FROM CLIENTE;

--Demasiadas filas
DECLARE 
    v_email CLIENTE.EMAIL%TYPE;
BEGIN 
    SELECT EMAIL INTO v_email FROM CLIENTE;
    DBMS_OUTPUT.PUT_LINE('El email es: ' || v_email);

EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No existe datos para el cliente que intenta consultar');
    
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Este bloque esta preparado para guardar una sola fila.' || CHR(1) || 'c:');
        DBMS_OUTPUT.PUT_LINE('Si desea guardar mas de una, por favor use un CURSOR');
END;
/


--División por cero
DECLARE
    v_resultado NUMBER;
    v_des NUMBER := 0;
BEGIN

    v_resultado := 100 / v_des ;
    DBMS_OUTPUT.PUT_LINE(v_resultado);
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('Error: no se puede dividir por cero.');
END;
/


INSERT INTO CLIENTE (rut, nombre, apellido, email)
    VALUES ('19.456.789-1', 'Pepito', 'Soto', 'psoto@gmail.com');


SELECT * FROM CLIENTE WHERE RUT = '19.456.789-1';
--Cuando un valor rompe criterio de unicidad
BEGIN
    INSERT INTO CLIENTE (rut, nombre, apellido, email)
    VALUES ('19.456.789-1', 'Pepito', 'Soto', 'psoto@gmail.com');
    -- El RUT '19.456.789-1' ya existe (Valentina Soto)
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Error: el RUT ya está registrado.');
END;
/

--Error de valor
DECLARE
    v_texto VARCHAR2(5);
BEGIN
    v_texto := 'Este texto es demasiado largo';
EXCEPTION
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Error: el valor excede el tamaño de la variable.');
END;
/

DECLARE
    v_num NUMBER;
BEGIN
    v_num := TO_NUMBER('abc');
EXCEPTION
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Error: no se pudo convertir a número.' || SQLERRM);
END;
/

CREATE OR REPLACE FUNCTION FN_NOMBRE (
    P_PARAMETRO IN NUMBER
)
RETURN NUMBER
AS
    V_RESULTADO NUMBER;
BEGIN
    SELECT COLUMNA
    INTO V_RESULTADO
    FROM TABLA
    WHERE ID = P_PARAMETRO;

    RETURN V_RESULTADO;
END FN_NOMBRE;
/
SELECT FN_VERIFICAR_STOCK(1)
FROM DUAL;

------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_NOMBRE (
    P_ID IN NUMBER,
    P_CANTIDAD IN NUMBER
)
AS
    V_STOCK NUMBER;
BEGIN
    SELECT STOCK_DISPONIBLE
    INTO V_STOCK
    FROM LOCALIDAD_EVENTO
    WHERE LOCALIDAD_EVENTO_ID = P_ID;

    IF V_STOCK <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'No hay stock disponible');
    END IF;

    UPDATE LOCALIDAD_EVENTO
    SET STOCK_DISPONIBLE = STOCK_DISPONIBLE - P_CANTIDAD
    WHERE LOCALIDAD_EVENTO_ID = P_ID;
END SP_NOMBRE;
/

DECLARE
    V_STOCK NUMBER;
BEGIN
    SP_OBTENER_STOCK(1, V_STOCK);

    DBMS_OUTPUT.PUT_LINE('Stock: ' || V_STOCK);
END;
/

------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE PKG_BOLETERIA IS
    G_TOTAL_ENTRADAS_VENDIDAS NUMBER := 0;

    FUNCTION FN_VERIFICAR_STOCK (
        P_LOCALIDAD_EVENTO_ID IN NUMBER
    ) RETURN NUMBER;

    PROCEDURE SP_ACTUALIZAR_STOCK (
        P_LOCALIDAD_EVENTO_ID IN NUMBER,
        P_ENTRADAS_VENDIDAS IN NUMBER
    );
END PKG_BOLETERIA;
/
CREATE OR REPLACE PACKAGE BODY PKG_BOLETERIA IS
    FUNCTION FN_VERIFICAR_STOCK (
        P_LOCALIDAD_EVENTO_ID IN NUMBER
    ) RETURN NUMBER
    AS
        V_STOCK NUMBER;
    BEGIN
        SELECT STOCK_DISPONIBLE
        INTO V_STOCK
        FROM LOCALIDAD_EVENTO
        WHERE LOCALIDAD_EVENTO_ID = P_LOCALIDAD_EVENTO_ID;
        RETURN V_STOCK;
    END FN_VERIFICAR_STOCK;

    PROCEDURE SP_ACTUALIZAR_STOCK (
        P_LOCALIDAD_EVENTO_ID IN NUMBER,
        P_ENTRADAS_VENDIDAS IN NUMBER
    )
    AS
        V_STOCK NUMBER;
    BEGIN
        V_STOCK := FN_VERIFICAR_STOCK(
            P_LOCALIDAD_EVENTO_ID
        );

        IF V_STOCK <= 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Sin entradas disponibles');
        END IF;

        UPDATE LOCALIDAD_EVENTO
        SET STOCK_DISPONIBLE = STOCK_DISPONIBLE - P_ENTRADAS_VENDIDAS
        WHERE LOCALIDAD_EVENTO_ID = P_LOCALIDAD_EVENTO_ID;

        G_TOTAL_ENTRADAS_VENDIDAS := G_TOTAL_ENTRADAS_VENDIDAS + P_ENTRADAS_VENDIDAS;
    END SP_ACTUALIZAR_STOCK;
END PKG_BOLETERIA;
/

DECLARE
    V_STOCK NUMBER;
BEGIN
    V_STOCK := PKG_BOLETERIA.FN_VERIFICAR_STOCK(1);
    PKG_BOLETERIA.SP_ACTUALIZAR_STOCK(1, 2);
    DBMS_OUTPUT.PUT_LINE('Stock consultado: ' || V_STOCK);
    DBMS_OUTPUT.PUT_LINE('Entradas vendidas: ' || PKG_BOLETERIA.G_TOTAL_ENTRADAS_VENDIDAS);
END;
/

------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_VALIDAR_STOCK
BEFORE UPDATE OF STOCK_DISPONIBLE
ON LOCALIDAD_EVENTO
FOR EACH ROW
BEGIN
    IF :NEW.STOCK_DISPONIBLE < 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'El stock no puede ser negativo');
    END IF;
END TRG_VALIDAR_STOCK;
/