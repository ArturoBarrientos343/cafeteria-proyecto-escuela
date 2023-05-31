<?php

class modelo_cafe {
    // propiedades de cafe
    private $id;
    private $nom;
    private $des;
    private $pre;
    private $img;
    private $est;
    
    function getId() {
        return $this->id;
    }

    function getNom() {
        return $this->nom;
    }

    function getDes() {
        return $this->des;
    }

    function getPre() {
        return $this->pre;
    }

    function getImg() {
        return $this->img;
    }

    function getEst() {
        return $this->est;
    }

    function setId($id) {
        $this->id = $id;
    }

    function setNom($nom) {
        $this->nom = $nom;
    }

    function setDes($des) {
        $this->des = $des;
    }

    function setPre($pre) {
        $this->pre = $pre;
    }

    function setImg($img) {
        $this->img = $img;
    }

    function setEst($est) {
        $this->est = $est;
    }

    private $base;
    private $cafe;
    
    
    public function __construct() {
        include_once 'conectar.php';
        $this->base = Conectar::conexion();
        $this->cafe = array();
    }
    
    public function ListadoCafes(){
        $cafe = $this->base -> query ("call usp_ListaCafes()");
        
        while ($fila = $cafe->fetch(PDO::FETCH_ASSOC)){
            $this-> cafe[] =  $fila;
        }
        return $this->cafe;
    }

       
    public function ingresar_cafe(){
        $sql = "call usp_IngresarCafe(?,?,?,?,?)";
        $sentencia= $this->base -> prepare ($sql);        
        $sentencia ->bindParam(1, $this->nom);
        $sentencia ->bindParam(2, $this->des);
        $sentencia ->bindParam(3, $this->pre);
        $sentencia ->bindParam(4, $this->img);
        $sentencia ->bindParam(5, $this->est);        
        if (!$sentencia){
            return 'Error de datos';
        }else{
            $sentencia->execute();
        }
    }
    
    public function editar_cafe($xid){
        $sql = "SELECT p.id_cafe, p.nom_cafe, p.des_cafe, p.pre_cafe, p.img_cafe, p.estado
                from cafes p where p.id_cafe=".$xid;
        
        $cafes = $this->base -> query ($sql);
        //Convierte a arreglo
        while ($fila = $cafes->fetch(PDO::FETCH_ASSOC)){
            $this-> cafe[] =  $fila;
        }
        return $this->cafe;
        
    }

    public function modificar_cafe(){
        $sql = "call usp_ModificaCafe(?,?,?,?,?,?)";
        $sentencia= $this->base -> prepare ($sql);        
        $sentencia ->bindParam(1, $this->id);
        $sentencia ->bindParam(2, $this->nom);
        $sentencia ->bindParam(3, $this->des);
        $sentencia ->bindParam(4, $this->pre);        
        $sentencia ->bindParam(5, $this->img);
        $sentencia ->bindParam(6, $this->est);        
        if (!$sentencia){
            return 'Error de datos';
        }else{
            $sentencia->execute();
        }
    }

    public function eliminar_cafe($id){
        $sql = "call usp_EliminarCafe(?);";
        $sentencia = $this->base ->prepare($sql);
        $sentencia->bindParam(1, $id);
        if (!$sentencia){
            return 'Error al eliminar cafe';
        }else{
            $sentencia->execute();
            return 'Eliminación correcta';
        }
    }
}
