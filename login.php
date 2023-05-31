<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/css/bootstrap.min.css" integrity="undefined" crossorigin="anonymous">
    <title>Shunshine for You | Login</title> 
    <link href="img/block.png" rel="shortcut icon" type="image/vnd.microsoft.icon" />  
</head>
<body style="background-color: rgb(223, 220, 220);">
    <div class="container col-lg-3" style="margin-top: 90px;">
        <div class="card col-sm-20">
            <div class="card-body">
                <form class="form-login" id="frmLogin" name="frmLogin" action="controlador/controlador_seguridad.php?opcion=1" method="POST" > 
                    <div class="form-group text-center" >
                        <h2 style="margin-bottom: 20px; color: #5F4C0B"">Sunshine for You</h2>
                        <img src="images/register.png" height="200" width="100%"/>                      
                    </div>
                    <div class="form-group" style="padding-top: 15px; margin-left:20px; margin-right:20px">
                        <label for="" style="margin-bottom: 10px; color: #5F4C0B" >Nombre de Usuario </label>
                        <input type="text" name="txtUsu" id="txtUsu" placeholder="Introduzca nombre de usuario" class="form-control">
                    </div>
                    <div class="form-group" style="margin-bottom: 10px;padding-top: 15px;margin-left:20px;margin-right:20px">
                        <label for="" style="margin-bottom: 10px; color: #5F4C0B"" >Contraseña</label>
                        <input type="password" name="txtCon" id="txtCon" placeholder="Introduzca contraseña" class="form-control">
                    </div>
                    <div class="form-group" style="margin-bottom: 20px;padding-top: 10px;margin-left:20px;margin-right:20px">
                        <label for=""><?php  if (isset($_GET['valor'])) echo $_GET['valor'];  ?></label>                        
                    </div>
                    <div style="text-align: right;margin-right:20px">
                        <input type="submit" name="accion" value="Iniciar sesión" onclick="validar()" class="btn btn-secondary" >
                    </div>
                    
                </form>

            </div>

        </div>
    </div>
    
</body>
</html>