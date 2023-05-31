<?php

class conectar {
    public static function conexion(){
        try{
            //PDO es una librería
            $cnx = new PDO('mysql:host=localhost;dbname=cafeteria','root','');
            $cnx -> setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            $cnx -> exec("SET CHARACTER SET UTF8");
            
        } catch (PDOException $ex) {
             echo 'Error de Base de datos : '.$ex ->getMessage();
             echo 'Linea de error : ' . $ex ->getLine();
        }    
        return $cnx;
    }
    
}

