B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=10.7
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: True
	#IncludeTitle: False
#End Region

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.

End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.


	Private Label1 As Label
	Private Label2 As Label
	Private EditText_nombre As EditText
	Private Label3 As Label
	Private EditText_apellido As EditText
	Private Label6 As Label
	Private EditText_Cargo As EditText
	Private Label7 As Label
	Private EditTextClave As EditText
	Private CheckBox_acepto As CheckBox
	Private Button_crear As Button
	Private Label4 As Label
	Private EditText_Documento As EditText
	Private CheckBox_admin As CheckBox
	Dim admin_val As Int
	
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("Crear_usuario")
	
	Label1.TextSize = Mod1.Scale_Font(30)
	
	Label2.TextSize = Mod1.Scale_Font(20)
	Label3.TextSize = Mod1.Scale_Font(20)
	Label4.TextSize = Mod1.Scale_Font(20)
	Label6.TextSize = Mod1.Scale_Font(20)
	Label7.TextSize = Mod1.Scale_Font(20)
	
	CheckBox_admin.TextSize = Mod1.Scale_Font(20)
	EditText_nombre.TextSize = Mod1.Scale_Font(20)
	EditTextClave.TextSize = Mod1.Scale_Font(20)
	EditText_apellido.TextSize = Mod1.Scale_Font(20)
	EditText_Cargo.TextSize = Mod1.Scale_Font(20)
	CheckBox_admin.TextSize = Mod1.Scale_Font(18)
	
	CheckBox_acepto.TextSize = Mod1.Scale_Font(18)
	
	Button_crear.TextSize = Mod1.Scale_Font(18)
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

								
Private Sub Button_crear_Click
	If  EditText_nombre.Text = "" Then
		MsgboxAsync("El campo Nombre no puede estar vacio","Error")
	Else
		If EditText_apellido.Text= "" Then
			MsgboxAsync("El campo Apellido no puede estar vacio","Error")
		Else
				If EditText_Cargo.Text= "" Then
					MsgboxAsync("El campo Cargo no puede estar vacio","Error")
				Else
					If EditText_Documento.Text.Length>=8 Then
							If EditTextClave.Text= "" Then
								MsgboxAsync("El campo Contraseña no puede estar vacio","Error")
							Else
									If CheckBox_acepto.Checked=True Then
										'MsgboxAsync("Intentando cargar Usuario","Ok")
							            If CheckBox_admin.checked=True Then
										admin_val=1
										Else
										admin_val=0
							            End If
										
										Guadar_datos
									Else
										MsgboxAsync("Debe aceptar el manejo de Datos","Error")
									End If
							End If
					Else
						MsgboxAsync("Documento con numeros faltantes","Error")
					End If
				End If	
		End If
	End If
End Sub



Sub Guadar_datos
	
	''   //https://movivallesas.com/test_conexion_v1.php?act=add&NOMBRE=pedro&AP=polo&DOC=7654321234&CARGO=mecanico&CLAVE=545343&ADMIN=1
	Try
		Dim PageServer As String = "https://araucariasolar.org/G35t1c.php"
		Dim js As HttpJob
		js.Initialize("", Me)
		js.download2(PageServer, Array As String ("act", "add",  "NOMBRE",EditText_nombre.Text,"AP",EditText_apellido.text,"DOC",EditText_Documento.text,"CARGO",EditText_Cargo.text,"CLAVE",EditTextClave.text,"ADMIN",admin_val))

		Wait For (js) JobDone(js As HttpJob)
		If js.Success Then
			Dim res As String
			res = js.GetString
			Dim parser As JSONParser
			parser.Initialize(res)
			If res <> False Then
				Dim Tabla As List
				Tabla = parser.NextArray
				If Tabla.Get(0)=0 Then
					ToastMessageShow("Datos Ingresados, Cliente registrado",False)
				Else
					MsgboxAsync("El cliente ingresado ya ha sido registrado o verifique su conexion a internet","Error")
				End If
			End If
		
		End If
	Catch
		Log(LastException)
	End Try
End Sub

