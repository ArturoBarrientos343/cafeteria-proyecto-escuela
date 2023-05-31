<?php

class modelo_detalle {
    // propiedades de detalle
    private $iddet;
    private $idcafe;
    private $idped;
    private $can;
    private $descto;
    
    function getIddet() {
        return $this->iddet;
    }

    function getIdcafe() {
        return $this->idcafe;
    }
    
    function getIdped() {
        return $this->idped;
    }

    function getCan() {
        return $this->can;
    }
    
    function getDescto() {
        return $this->descto;
    }

    function setIddet($iddet) {
        $this->iddet = $iddet;
    }

    function setIdped($idped) {
        $this->idped = $idped;
    }

    function setIdcafe($idcafe) {
        $this->idcafe = $idcafe;
    }

    function setCan($can) {
        $this->can = $can;
    }   

    function setDescto($descto) {
        $this->descto = $descto;
    }   

    private $base;
    private $cafe;
    
    
    public function __construct() {
        include_once 'conectar.php';
        $this->base = Conectar::conexion();
        $this->cafe = array();
    }
    
    public function ListadoDetalles(){
        $cafe = $this->base -> query ("call usp_ListaDetalles()");
        
        while ($fila = $cafe->fetch(PDO::FETCH_ASSOC)){
            $this-> cafe[] =  $fila;
        }
        return $this->cafe;
    }

    public function ListadoDetalles2($xped){
        $cafe = $this->base -> query ("SELECT d.id_det, p.id_cafe, p.nom_cafe, d.can_cafe, d.descto, d.imp_cafe, d.can_dev
        from detalle d inner join cafes p on d.id_cafe=p.id_cafe WHERE id_ped=".$xped);
        
        while ($fila = $cafe->fetch(PDO::FETCH_ASSOC)){
            $this-> cafe[] =  $fila;
        }
        return $this->cafe;
    }
       
    public function ingresar_Detalle(){
        $sql = "call usp_IngresarDetalle(?,?,?)";
        $sentencia= $this->base -> prepare ($sql);        
        $sentencia ->bindParam(1, $this->idcafe);
        $sentencia ->bindParam(2, $this->can);
        $sentencia ->bindParam(3, $this->descto);

        if (!$sentencia){
            return 'Error de datos';
           
        }else{            
            $sentencia->execute();
        }
    }
    
    public function Eliminar_Detalle($id){
        $sql = "call usp_EliminarDetalle(?);";
        $sentencia = $this->base ->prepare($sql);
        $sentencia->bindParam(1, $id);
        if (!$sentencia){
            echo 0;
            return 'Error al eliminar el cliente';
            
        }else{
            echo 1;
            $sentencia->execute();
            return 'Eliminación correcta';
        }
    }

    public function actualizar_detalle(){
        $sql = "call usp_ActualizarDetalle(?,?,?)";
        $sentencia= $this->base -> prepare ($sql);        
        $sentencia ->bindParam(1, $this->iddet);
        $sentencia ->bindParam(2, $this->idcafe);
        $sentencia ->bindParam(3, $this->can);

        if (!$sentencia){            
           
        }else{            
            $sentencia->execute();            
        }
        
    }
    
}
