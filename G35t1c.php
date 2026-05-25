<?php

	$host = "araucariasolar.org";
        $host = "localhost";
    
	$user = "u318851812_admin0";
	$pw = "8Nb|^|a=";
	$db = "u318851812_GESTIC";   
	$conDB = new mysqli($host, $user, $pw, $db);
	$conDB->set_charset("utf8");

    $action =  $_GET["act"];
    
    
//https://araucariasolar.org/G35t1c.php?act=Rall1
//https://araucariasolar.org/G35t1c.php?act=C1&CC=0987654
//https://araucariasolar.org/G35t1c.php?act=add&NAME=LUIS&LASTN=RODRIGUEZ&ID=0987654
//https://araucariasolar.org/G35t1c.php?act=dele&CCborrar=1234


//case 'dele':
//$DOC1=  $_GET["CCborrar"];     
     

    switch ($action) {
       
        case 'add':
     
        $Nombre=  $_GET["NOMBRE"];     
        $apellido=  $_GET["NOMBRE"];     
        $Cargo =$_GET["CARGO"]; 
        $Doc=  $_GET["DOC"];
        $pass =$_GET["CLAVE"]; 
        $ad=$_GET["ADMIN"];
        
        
        $sql = "INSERT INTO `empleados` (`id`, `nombres`, `apellidos`, `cargo`, `documento`, `contrasena`, `es_admin`, `fecha_creacion`) VALUES (NULL, '$Nombre', '$apellido', '$Cargo', '$Doc', '$pass', '$ad', current_timestamp());";
            
        $result = $conDB->query($sql);
        $rows = array();
        $rows[]= mysqli_errno($conDB); // NUEMRO DE ERROR 0--> NO ERROR
		$rows[]= mysqli_error($conDB); // DETALLE		
	  	print json_encode($rows);
        break;
        
        
        
        case 'Rall1':  // leeemnos todo
        $sql = "SELECT * FROM `empleados` WHERE 1;";
        $q =$conDB->query($sql); // ejecuta peticion
		$rows = array();
		while($r = mysqli_fetch_assoc($q)) // lee cada fila
		{
			$rows[] = $r;
		}
		print json_encode($rows); // envia datos devuelta
        break;
        
              

       case 'C1':   // filtro dato para verificar contrase�a y usuario
       $Doc=  $_GET["CC"];     
       $sql = "SELECT * FROM `empleados` WHERE documento='$Doc';";
          
        $q =$conDB->query($sql); // ejecuta peticion
		$rows = array();
		while($r = mysqli_fetch_assoc($q)) // lee cada fila
		{
			$rows[] = $r;
		}
		print json_encode($rows); // envia datos devuelta       
        break;
        
        
        case 'dele':

        $DOC1=  $_GET["CCborrar"];     

        $sql = "DELETE FROM `prueba` WHERE CEDULA='$DOC1';";
        $result = $conDB->query($sql);
        $rows = array();
        $rows[]= mysqli_errno($conDB); // NUEMRO DE ERROR 0--> NO ERROR
	    $rows[]= mysqli_error($conDB); // DETALLE		
  	    print json_encode($rows);
        break;
        
        

}
    mysqli_close($conDB);
   
?>
