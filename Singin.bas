B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=10.7
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: False
	#IncludeTitle: False
#End Region

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
	
	Public name,ape, cargo, clave, doc,admin As String
End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.

	Private Button_Abrir As Button
	Private EditText_nombre As EditText
	Private EditText_apellido As EditText
	Private EditText_clave As EditText
	Private Label1 As Label
	Private Label2 As Label
	Private Label3 As Label
	Private Label4 As Label
	Private ImageView2 As ImageView
	Private ImageView1 As ImageView
	Private WebView1 As WebView
	Private ImageView_info As ImageView
	Private ImageView_maps As ImageView
	Private Panel_ubicacion As Panel
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("iniciar_sesion")
	
	Panel_ubicacion.Visible=False
	Panel_ubicacion.Enabled=False
	
	Label1.TextSize = Mod1.Scale_Font(30)
	Label4.TextSize = Mod1.Scale_Font(25)
	
	Label2.TextSize = Mod1.Scale_Font(20)
	Label3.TextSize = Mod1.Scale_Font(20)
	
	EditText_nombre.TextSize = Mod1.Scale_Font(20)
	EditText_clave.TextSize = Mod1.Scale_Font(20)
	Button_Abrir.TextSize = Mod1.Scale_Font(20)
	
	WebView1.JavaScriptEnabled = True
	WebView1.ZoomEnabled = True
	
	Dim url As String
	url = "https://www.google.com/maps?ll=10.480572,-73.255164&z=16&t=m&hl=es&gl=US&mapclient=embed&q=Cra.+13+%23+9C-33+Valledupar,+Cesar"

	WebView1.LoadUrl(url)
	
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub


Private Sub Button_Abrir_Click
	If EditText_nombre.Text = "" Then
		MsgboxAsync("Debe escribir su numero de documento en el campo de usuario","Error")
	Else
		If EditText_clave.Text = "" Then
			MsgboxAsync("Debe escribir su clave personal en el campo Contraseña","Error")
		Else
					
				Dim intentos As Int = 0
				Dim maxIntentos As Int = 5

				Do While doc.Length = 0 And intentos < maxIntentos
					Leer_dato
					Sleep(500)
					intentos = intentos + 1
				Loop

				If doc.Length = 0 Then
					ToastMessageShow("Falló la lectura. Intentos realizados: " & intentos, True)
				Else
					Log("Dato leído correctamente: " & doc & "intentos: " & intentos)
				End If
				
			If EditText_nombre.Text=doc Then
				If EditText_clave.Text=clave Then
					Activity.Finish
					If admin= "1" Then
						StartActivity(admin1)
					Else
						StartActivity(Camara)
					End If
				Else
					MsgboxAsync("contraseña no coincide","Error")
				End If
			Else
				MsgboxAsync("Usuario no coincide","Error")
			End If
		End If
	End If
End Sub

Sub Leer_dato
	Try
		'electronicaunicesar.com.co/c0m3l0n@_3xpr355.php?act=Cus&CC=1234567890
		Dim PageServer As String = "https://araucariasolar.org/G35t1c.php"
		Dim js As HttpJob
		Dim js As HttpJob
		js.Initialize("", Me)
		js.download2(PageServer, Array As String ("act", "C1","CC",EditText_nombre.text))
	
		Wait For (js) JobDone(js As HttpJob)
		If js.Success Then
			Dim res As String
			res = js.GetString
			Dim parser As JSONParser
			parser.Initialize(res)
			If res <> False Then
				Dim Tabla As List
				Tabla = parser.NextArray
				Dim Fila As Map
				For i=0 To Tabla.size-1
					Fila =  Tabla.Get(i)
							
					name = Fila.Get("nombres")
					ape = Fila.Get("apellidos")
					doc= Fila.Get("documento")
					cargo = Fila.Get("cargo")
					clave =  Fila.Get("contrasena")
					admin=Fila.Get("es_admin")
					
					Log(doc)
					Log(clave)
					
				Next
			End If
		End If
	Catch
		Log(LastException)
	End Try
End Sub



Private Sub ImageView_maps_Click
	Panel_ubicacion.Visible = Not(Panel_ubicacion.Visible)
End Sub



Sub EncodeUrl(Texto As String) As String
	Dim su As StringUtils
	Return su.EncodeUrl(Texto, "UTF8")
End Sub


Private Sub ImageView_info_Click
	
	Dim numero As String = "573043611183" ' 
	Dim mensaje As String = "Hola, necesito soporte con el aplicativo móvil. Tengo un inconveniente y requiero ayuda."

	Dim url As String
	url = "https://wa.me/" & numero & "?text=" & EncodeUrl(mensaje)

	Dim i As Intent
	i.Initialize(i.ACTION_VIEW, url)
	StartActivity(i)
End Sub