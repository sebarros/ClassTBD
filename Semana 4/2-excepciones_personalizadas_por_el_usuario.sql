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