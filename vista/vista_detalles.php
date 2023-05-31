<?php
$status = session_status();
if($status == PHP_SESSION_NONE){
    //There is no active session
    session_start();
    
}
?>
<!doctype html>
<html lang="es">
  <head>
     
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
    
  </head>
  <body>
  <script>
    $(document).ready(function(){

        function loadTableData(){
            $.ajax({
                url : "../controlador/controlador_detalle.php",
                type : "GET",
                data:{opcion:1},                  
                success:function(data){
                    $("#central").html(data);
                }
            });
        }       

        $(document).on("click",".borrar-btn",function(){
            if (confirm("¿Estás seguro de eliminar esto?")) {
                var id = $(this).data('id');
                //var element = this;
                $.ajax({
                    url :"../controlador/controlador_detalle.php",
                    type:"GET",
                    cache:false,
                    data:{opcion:5,borrarId:id},
                    success:function(data){
                        if (data == 1) {
                            loadTableData();
                            //$(element).closest("tr").fadeOut();
                                //alert("Registro de usuario eliminado correctamente"); 
                        }else{
                            alert("Identificación de usuario inválida");
                        }
                    }
                });
            }
        });
    });


  </script>
<!-- para ejemplo simple -->
<div class="container" style="margin-top:15px">
<table id="tablaING" class="table" style="width:100%">
    <thead>
            <tr>
                               
                <th>CAFE</th>
                <th>CANTIDAD</th>
                <th>PRECIO</th>
                <th>DESCTO</th>
                <th>IMPORTE</th>                               
                <th>Eliminar</th>
            </tr>
    </thead>      
    <tbody>
        
        
        <?php
            //La estructura foreach trabaja con colecciones o arreglos
            $tot=0;
            $tot_cafe=0;
            foreach($RegistrosCafes as $reg){
                echo '<tr>';
                                        
                echo '<td>'.$reg['nom_cafe'].'</td>';                       
                echo '<td>'.$reg['can_cafe'].'</td>';
                echo '<td>'.($reg['imp_cafe']/$reg['can_cafe']).'</td>';
                echo '<td>'.$reg['descto'].'</td>';
                echo '<td>'.$reg['imp_cafe'].'</td>';
                echo "<td><button class='btn btn-warning btn-sm borrar-btn' data-id='{$reg['id_det']}'>Eliminar</button></td>";                
                echo '</tr>';
                $tot = $tot + $reg['imp_cafe'];
                $tot_cafe = $tot_cafe + $reg['can_cafe'];
                
            }
            echo '<tr>';                                           
            echo '<td>Totales</td>';                       
            echo '<td>'.$tot_cafe.' cafes</td>';
            echo '<td></td>';
            echo '<td></td>';
            echo '<td>'.$tot.' soles</td>';
            echo '<td></td>';
            echo '</tr>';
            
            $_SESSION['total_pedido'] = $tot;
            
            
        ?> 
        
     
    </tbody>
        
    </table>
    <?php
    
    ?>
  </div>
    </body>
    
</html>