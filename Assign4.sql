-- Code using Implicit Cursor
DECLARE
    v_count NUMBER;
BEGIN

    FOR rec IN (SELECT Roll_no, Name FROM N_RollCall)
    LOOP

        SELECT COUNT(*)
        INTO v_count
        FROM O_RollCall
        WHERE Roll_no = rec.Roll_no;

        IF v_count = 0 THEN

            INSERT INTO O_RollCall(Roll_no, Name)
            VALUES(rec.Roll_no, rec.Name);

            DBMS_OUTPUT.PUT_LINE(
                'Inserted: ' || rec.Roll_no || ' ' || rec.Name
            );

        ELSE

            DBMS_OUTPUT.PUT_LINE(
                'Skipped: ' || rec.Roll_no || ' already exists'
            );

        END IF;

    END LOOP;

    COMMIT;

END;
/

-- EXPLICIT CURSOR
DECLARE

    CURSOR c_new_students IS
        SELECT Roll_no, Name
        FROM N_RollCall;

    v_count NUMBER;

    v_roll_no N_RollCall.Roll_no%TYPE;
    v_name    N_RollCall.Name%TYPE;

BEGIN

    OPEN c_new_students;

    LOOP

        FETCH c_new_students
        INTO v_roll_no, v_name;

        EXIT WHEN c_new_students%NOTFOUND;

        SELECT COUNT(*)
        INTO v_count
        FROM O_RollCall
        WHERE Roll_no = v_roll_no;

        IF v_count = 0 THEN

            INSERT INTO O_RollCall(Roll_no, Name)
            VALUES(v_roll_no, v_name);

            DBMS_OUTPUT.PUT_LINE(
                'Inserted: ' || v_roll_no || ' ' || v_name
            );

        ELSE

            DBMS_OUTPUT.PUT_LINE(
                'Skipped: ' || v_roll_no || ' already exists'
            );

        END IF;

    END LOOP;

    CLOSE c_new_students;

    COMMIT;

END;
/



-- CURSOR FOR LOOP
DECLARE

    CURSOR c_new_students IS
        SELECT Roll_no, Name
        FROM N_RollCall;

    v_count NUMBER;

BEGIN

    FOR rec IN c_new_students
    LOOP

        SELECT COUNT(*)
        INTO v_count
        FROM O_RollCall
        WHERE Roll_no = rec.Roll_no;

        IF v_count = 0 THEN

            INSERT INTO O_RollCall(Roll_no, Name)
            VALUES(rec.Roll_no, rec.Name);

            DBMS_OUTPUT.PUT_LINE(
                'Inserted: ' || rec.Roll_no || ' ' || rec.Name
            );

        ELSE

            DBMS_OUTPUT.PUT_LINE(
                'Skipped: ' || rec.Roll_no || ' already exists'
            );

        END IF;

    END LOOP;

    COMMIT;

END;
/


-- Parameterized Cursor solution for your assignment

DECLARE

    CURSOR c_new_students(p_roll NUMBER) IS
        SELECT Roll_no, Name
        FROM N_RollCall
        WHERE Roll_no = p_roll;

    v_count NUMBER;

BEGIN

    FOR r IN (SELECT Roll_no FROM N_RollCall)
    LOOP

        SELECT COUNT(*)
        INTO v_count
        FROM O_RollCall
        WHERE Roll_no = r.Roll_no;

        IF v_count = 0 THEN

            FOR rec IN c_new_students(r.Roll_no)
            LOOP

                INSERT INTO O_RollCall(Roll_no, Name)
                VALUES(rec.Roll_no, rec.Name);

                DBMS_OUTPUT.PUT_LINE(
                    'Inserted: ' ||
                    rec.Roll_no || ' ' ||
                    rec.Name
                );

            END LOOP;

        ELSE

            DBMS_OUTPUT.PUT_LINE(
                'Skipped: ' ||
                r.Roll_no ||
                ' already exists'
            );

        END IF;

    END LOOP;

    COMMIT;

END;
/