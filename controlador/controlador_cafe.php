<?php
include_once '../modelo/modelo_cafe.php';

//Obtener la variable
$xop = $_GET['opcion'];

switch ($xop){
    case 1:
        listado_cafe();
        break;
    case 2:
        ingresar_cafe();
        listado_cafe();
        break;        
    case 3:
        editar_cafe();        
        break;
    case 4:
        modificar_cafe();        
        listado_cafe();
        break;
    case 5:
        eliminar_cafe();        
        listado_cafe();
        break;    
}
function listado_cafe(){
    $reg = new modelo_cafe();
    $RegistrosCafes = $reg ->ListadoCafes();    
    include_once '../vista/vista_cafes.php';
}
function editar_cafe(){
    $xid = $_GET['id'];    
    $reg = new modelo_cafe();
    $RegistrosCafes = $reg-> editar_cafe($xid);    
    include_once '../vista/vista_edi_cafe.php';
}

function eliminar_cafe(){
    $xid = $_GET['id'];    
    $reg = new modelo_cafe();
    $reg-> eliminar_cafe($xid);    
    
}


function ingresar_cafe(){    
    $xnom = $_POST['txtNom'];
    $xdes = $_POST['txtDes'];
    $xpre = $_POST['txtPre'];
    $ximg = $_FILES['txtImg']['name'];
    $xest = 'A';
    
    $reg = new modelo_cafe();
    $reg ->setNom($xnom);
    $reg ->setDes($xdes);
    $reg ->setPre($xpre);
    $reg ->setImg($ximg);
    $reg ->setEst($xest);
    
    $ruta = $_FILES['txtImg']['tmp_name'];
    $destino = '../Fotos/Cafe/';
    
    //Subimos y preguntamos si está OK
    if (!copy($ruta, $destino.$ximg)){
        echo 'Subida de imagen fallida';
    }    
    $reg->ingresar_cafe();    
}

function modificar_cafe(){  
    
    $xid = $_POST['txtId'];
    $xnom = $_POST['txtNom'];
    $xdes = $_POST['txtDes'];
    $xpre = $_POST['txtPre'];
    $ximg = $_FILES['txtImg']['name'];
    $xest = $_POST['txtEst'];
    
    $reg = new modelo_cafe();
    $reg ->setId($xid);
    $reg ->setNom($xnom);
    $reg ->setDes($xdes);
    $reg ->setPre($xpre);
    $reg ->setImg($ximg);
    $reg ->setEst($xest);
    
    $ruta = $_FILES['txtImg']['tmp_name'];
    $destino = '../Fotos/Cafe/';
    //Subimos y preguntamos si está OK
    if (!copy($ruta, $destino.$ximg)){
        echo 'Subida de imagen fallida';
    }    
    $reg->modificar_cafe();    
}

function combo_cafes(){
    $reg= new modelo_cafe();
    $cafes = $reg ->ListadoCafes();
    
    foreach ($cafes as $fila){                
        echo "<option value=".$fila['id_cafe'].">".$fila['nom_cafe']."</option>";                
    }
}

?>

