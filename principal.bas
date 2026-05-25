B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=10.7
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: TRUE
	#IncludeTitle: FALSE
#End Region

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.

End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.
	
	Private ImageView1 As ImageView
	Private ImageView2 As ImageView
	Private ButtonReg As Button
	Private ImageViewHamburguesa As ImageView
	Private ImageViewPerro As ImageView
	Private ImageViewSalchipapa As ImageView
	Private PanelSalchipapa As Panel
	Private Panel10 As Panel
	Private ImageView9 As ImageView
	Private Label26 As Label
	Private Label27 As Label
	Private Label28 As Label
	Private Label29 As Label
	Private EditText8 As EditText
	Private Buttonmas8 As Button
	Private Buttonmenos8 As Button
	Private Panel11 As Panel
	Private ImageView10 As ImageView
	Private Label30 As Label
	Private Label31 As Label
	Private Label32 As Label
	Private Label33 As Label
	Private EditText7 As EditText
	Private Buttonmas7 As Button
	Private Buttonmenos7 As Button
	Private Panel12 As Panel
	Private ImageView11 As ImageView
	Private Label34 As Label
	Private Label35 As Label
	Private Label36 As Label
	Private Label37 As Label
	Private EditTex6 As EditText
	Private Buttonmas6 As Button
	Private Buttonmenos6 As Button
	Private Panelperro As Panel
	Private Panel7 As Panel
	Private ImageView7 As ImageView
	Private Label18 As Label
	Private Label19 As Label
	Private Label20 As Label
	Private Label21 As Label
	Private EditText5 As EditText
	Private Buttonmas5 As Button
	Private Buttonmenos5 As Button
	Private Panel8 As Panel
	Private ImageView8 As ImageView
	Private Label22 As Label
	Private Label23 As Label
	Private Label24 As Label
	Private Label25 As Label
	Private EditText4 As EditText
	Private Buttonmas4 As Button
	Private Buttonmenos4 As Button
	Private PanelHamburguesa As Panel
	Private Panel4 As Panel
	Private ImageView5 As ImageView
	Private Label10 As Label
	Private Label11 As Label
	Private Label12 As Label
	Private Label13 As Label
	Private EditText3 As EditText
	Private Buttonmas3 As Button
	Private Buttonmenos3 As Button
	Private Panel3 As Panel
	Private ImageView4 As ImageView
	Private Label6 As Label
	Private Label7 As Label
	Private Label8 As Label
	Private Label9 As Label
	Private EditText2 As EditText
	Private Buttonmas2 As Button
	Private Buttonmenos2 As Button
	Private Panel2 As Panel
	Private ImageView3 As ImageView
	Private Label2 As Label
	Private Label3 As Label
	Private Label4 As Label
	Private Label5 As Label
	Private EditText1 As EditText
	Private Buttonmas1 As Button
	Private Buttonmenos1 As Button
	Private ButtonCarrito As Button
	Private Label1 As Label
		
	Dim Timer1 As Timer
	
	Dim Alpha = 0 As Float
	Private ImageViewescogido As ImageView

	Dim escogido=0 As Int
	
	Private Labelproducto As Label
	Private ImageViewanimacion As ImageView
	
	Private Button_resetear As Button
	Private Button_venta As Button
	
	Dim var_casilla1=0 As Int
	Dim var_casilla2=0 As Int
	Dim var_casilla3=0 As Int
	Dim var_casilla4=0 As Int
	Dim var_casilla5=0 As Int
	Dim var_casilla6=0 As Int
	Dim var_casilla7=0 As Int
	Dim var_casilla8=0 As Int
	
	
	Private EditText6 As EditText
	Private Button_ventas As Button
	Private Button_inv As Button
	
	Dim var_la_suprema=15000 As Int
	Dim var_chicago=13000 As Int
	Dim var_magna=15900 As Int
	
	Dim var_la_imperial=15000 As Int
	Dim var_doggie=10000 As Int
	
	Dim var_la_soberana=18000 As Int
		
	Dim var_ganacia=0.43 As Float
		
	Dim var_neta_la_suprema=15000*var_ganacia As Int
	Dim var_neta_chicago=13000*var_ganacia As Int
	Dim var__neta_magna=15900*var_ganacia As Int
	
	Dim var__neta_la_imperial=15000*var_ganacia As Int
	Dim var__neta_doggie=10000*var_ganacia As Int
	
	Dim var__neta_la_soberana=18000*var_ganacia As Int
	
	Dim ganancia_bruta As Int
	Dim ganancia_neta As Int
	
	Dim referencia="" As String
	
	
		
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("MENU")
	Log(Singin.admin)
		
    Label1.Text= DateTime.GetYear(DateTime.Now) & "-" & DateTime.GetMonth(DateTime.Now) & "-"  & DateTime.GetDayOfMonth(DateTime.Now) & " " & DateTime.GetHour(DateTime.Now) & ":" & DateTime.GetMinute(DateTime.Now) & ":" & DateTime.GetSecond(DateTime.Now)
	
	If Singin.admin==0 Then
		ButtonReg.visible=False
		ButtonReg.enabled=False
	Else
		ButtonReg.visible=True
		ButtonReg.enabled=True
	End If
	
	Timer1.Initialize("Timer1", 1)
	Timer1.Enabled = True
	
	EditText1.Text=var_casilla1
	EditText2.Text=var_casilla1
	EditText3.Text=var_casilla1
	EditText4.Text=var_casilla1
	EditText5.Text=var_casilla1
	EditText6.Text=var_casilla1
	EditText7.Text=var_casilla1
	EditText8.Text=var_casilla1
	

End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub


Sub Timer1_Tick 
	
	
End Sub

'////////////////////////////////////////////7777777777777777777777777777777777777777777777777777777777777
'
Private Sub ButtonCarrito_Click
	
End Sub

Private Sub Buttonmenos1_Click
	If var_casilla1>=1 Then
		var_casilla1=var_casilla1-1
		EditText1.Text=var_casilla1
	End If
End Sub

Private Sub Buttonmas1_Click
	var_casilla1=var_casilla1+1
	EditText1.Text=var_casilla1
End Sub

Private Sub Buttonmenos2_Click
	If var_casilla2>=1 Then
		var_casilla2=var_casilla2-1
		EditText2.Text=var_casilla2
	End If
End Sub

Private Sub Buttonmas2_Click
	var_casilla2=var_casilla2+1
	EditText2.Text=var_casilla2
End Sub

Private Sub Buttonmenos3_Click
	If var_casilla3>=1 Then
		var_casilla3=var_casilla3-1
		EditText3.Text=var_casilla3
	End If
End Sub

Private Sub Buttonmas3_Click
	var_casilla3=var_casilla3+1
	EditText3.Text=var_casilla3
End Sub

Private Sub Buttonmenos4_Click
	If var_casilla4>=1 Then
		var_casilla4=var_casilla4-1
		EditText4.Text=var_casilla4
	End If
End Sub

Private Sub Buttonmas4_Click
	var_casilla4=var_casilla4+1
	EditText4.Text=var_casilla4
End Sub

Private Sub Buttonmenos5_Click
	If var_casilla5>=1 Then
		var_casilla5=var_casilla5-1
		EditText5.Text=var_casilla5
	End If
End Sub

Private Sub Buttonmas5_Click
	var_casilla5=var_casilla5+1
	EditText5.Text=var_casilla5
End Sub

Private Sub Buttonmenos6_Click
	If var_casilla6>=1 Then
		var_casilla6=var_casilla6-1
		EditText6.Text=var_casilla6
	End If
	
End Sub

Private Sub Buttonmas6_Click
	var_casilla6=var_casilla6+1
	EditText6.Text=var_casilla6
End Sub

Private Sub Buttonmenos7_Click
	If var_casilla7>=1 Then
		var_casilla7=var_casilla7-1
		EditText7.Text=var_casilla7
	End If

End Sub

Private Sub Buttonmas7_Click
	var_casilla7=var_casilla7+1
	EditText7.Text=var_casilla7
End Sub

Private Sub Buttonmenos8_Click
	If var_casilla8>=1 Then
		var_casilla8=var_casilla8-1
		EditText8.Text=var_casilla8
	End If

End Sub

Private Sub Buttonmas8_Click
	var_casilla8=var_casilla8+1
	EditText8.Text=var_casilla8
End Sub



Private Sub ButtonReg_Click
	StartActivity(crear_usuario)
End Sub


''/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
''/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Private Sub ImageViewescogido_Click
	
	ImageViewPerro.Visible=True
	ImageViewHamburguesa.Visible=True
	ImageViewSalchipapa.Visible=True
	ImageViewescogido.Visible=False
	ImageViewescogido.Enabled=False
	
'	ImageViewanimacion.Width=ImageViewHamburguesa.Width
'	ImageViewanimacion.Height=ImageViewHamburguesa.Height
'			
'	If escogido==1 Then
'		ImageViewanimacion.Bitmap=LoadBitmap(File.DirAssets, "hamburguesa.png")
'		ImageViewanimacion.Left=ImageViewHamburguesa.Left
'		ImageViewanimacion.Top=ImageViewHamburguesa.Top
'		
'	else if escogido==2 Then
'		ImageViewanimacion.Bitmap=LoadBitmap(File.DirAssets, "perros1.png")
'	
'		ImageViewanimacion.Left=ImageViewPerro.Left
'		ImageViewanimacion.Top=ImageViewPerro.Top
'	
'	else if escogido==3 Then
'	
'		ImageViewanimacion.Left=ImageViewSalchipapa.Left
'		ImageViewanimacion.Top=ImageViewSalchipapa.Top
'	
'		ImageViewanimacion.Bitmap=LoadBitmap(File.DirAssets, "salchipapa.png")
'	End If
End Sub

Private Sub ImageViewSalchipapa_Click

	
	ImageViewescogido.Visible=True
	
	escogido=3
	ImageViewescogido.Bitmap=LoadBitmap(File.DirAssets, "salchipapa.png")
	Labelproducto.Text="Salchipapas"
	
	PanelHamburguesa.Visible=False
	Panelperro.Visible=False
	PanelSalchipapa.Visible=False
	
	
	PanelSalchipapa.Visible=True
	ImageViewescogido.Enabled=True
	
	ImageViewPerro.Visible=False
	ImageViewHamburguesa.Visible=False
	ImageViewSalchipapa.Visible=False
End Sub

Private Sub ImageViewPerro_Click

	
	ImageViewescogido.Visible=True
	
	escogido=2
	ImageViewescogido.Bitmap=LoadBitmap(File.DirAssets, "perros1.png")
	Labelproducto.Text="Perros"
	
	
	PanelHamburguesa.Visible=False
	Panelperro.Visible=False
	PanelSalchipapa.Visible=False
	
	Panelperro.Visible=True
	ImageViewescogido.Enabled=True
	
	ImageViewPerro.Visible=False
	ImageViewHamburguesa.Visible=False
	ImageViewSalchipapa.Visible=False
End Sub

Private Sub ImageViewHamburguesa_Click
	
	
	escogido=1
	ImageViewescogido.Bitmap=LoadBitmap(File.DirAssets, "hamburguesa.png")
	Labelproducto.Text="Hamburguesas"

	PanelHamburguesa.Visible=False
	Panelperro.Visible=False
	PanelSalchipapa.Visible=False
	
	PanelHamburguesa.Visible=True
	ImageViewescogido.Enabled=True
	
	ImageViewPerro.Visible=False
	ImageViewHamburguesa.Visible=False
	ImageViewSalchipapa.Visible=False
	ImageViewescogido.Visible=True
	
End Sub

Private Sub Button_venta_Click
	 
	If var_casilla1>0 Then
		referencia=referencia & " La suprema=" & var_casilla1 & " - " ' "/r/n"
	End If
	
	If var_casilla2>0 Then
		referencia=referencia & " La chicago=" & var_casilla2 & " - "'"/r/n"
	End If

	If var_casilla3>0 Then
		referencia=referencia & " La magna=" & var_casilla3 & " - "'"/r/n"
	End If
	
	If var_casilla4>0 Then
		referencia=referencia & " La imperial=" & var_casilla4 & " - "'"/r/n"
	End If
	
	If var_casilla5>0 Then
		referencia=referencia & " Doggie=" & var_casilla5 & " - "'"/r/n"
	End If
	
	If var_casilla6>0 Then
		referencia=referencia & " La soberana=" & var_casilla6 & " - "'"/r/n"
	End If
	
	
	ganancia_bruta=var_la_suprema*var_casilla1+var_chicago*var_casilla2+var_magna*var_casilla3+var_la_imperial*var_casilla4+var_doggie*var_casilla5+var_la_soberana*var_casilla6
	ganancia_neta=ganancia_bruta*var_ganacia
	
	'Dim var_la_suprema=15000 As Int
	'Dim var_chicago=13000 As Int
	'Dim var_magna=15900 As Int
	
	'Dim var_la_imperial=15000 As Int
	'Dim var_doggie=10000 As Int
	
	'Dim var_la_soberana=18000 As Int
	
	
	Label1.Text= DateTime.GetYear(DateTime.Now) & "-" & DateTime.GetMonth(DateTime.Now) & "-"  & DateTime.GetDayOfMonth(DateTime.Now) & " " & DateTime.GetHour(DateTime.Now) & ":" & DateTime.GetMinute(DateTime.Now) & ":" & DateTime.GetSecond(DateTime.Now)
	venta_datos
	
	var_casilla1=0
	var_casilla2=0
	var_casilla3=0
	var_casilla4=0
	var_casilla5=0
	var_casilla6=0
	var_casilla7=0
	var_casilla8=0
		
	EditText1.Text=var_casilla1
	EditText2.Text=var_casilla1
	EditText3.Text=var_casilla1
	EditText4.Text=var_casilla1
	EditText5.Text=var_casilla1
	EditText6.Text=var_casilla1
	EditText7.Text=var_casilla1
	EditText8.Text=var_casilla1
	
	referencia=""
	
End Sub

Private Sub Button_resetear_Click
	var_casilla1=0
	var_casilla2=0
	var_casilla3=0
	var_casilla4=0
	var_casilla5=0
	var_casilla6=0
	var_casilla7=0
	var_casilla8=0
		
	EditText1.Text=var_casilla1
	EditText2.Text=var_casilla1
	EditText3.Text=var_casilla1
	EditText4.Text=var_casilla1
	EditText5.Text=var_casilla1
	EditText6.Text=var_casilla1
	EditText7.Text=var_casilla1
	EditText8.Text=var_casilla1
	
	referencia=""
End Sub


''//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
''//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
''//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Sub venta_datos
	
	''  electronicaunicesar.com.co/c0m3l0n@_3xpr355.php?act=Nventa&CNT=perros&VAL=320000&APE=PERE&Fecha=2022-11-14 23:24:56
	Try
		Dim PageServer As String = "electronicaunicesar.com.co/c0m3l0n@_3xpr355.php"
		Dim js As HttpJob
		js.Initialize("", Me)
		js.download2(PageServer, Array As String ("act", "Nventa",  "Nombre",referencia,"VLRNETO", ganancia_neta,"VLRBRUTO",ganancia_bruta))

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
					ToastMessageShow("Venta Registrada, Valor Neto: $" & ganancia_bruta ,False)
				Else
					MsgboxAsync("La venta Registrada no ha podido ser Registrada","Error")
				End If
			End If
		
		End If
	Catch
		Log(LastException)
	End Try
End Sub



Private Sub Button_inv_Click
	StartActivity(Camara)
End Sub

Private Sub Button_ventas_Click
	StartActivity(ventas)
End Sub