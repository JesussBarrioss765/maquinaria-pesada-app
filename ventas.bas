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

End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.
	Public N1 As Int
	Private Label1 As Label
	Private Panel1 As ScrollView
	Private EditText1 As EditText
	Private Label2 As Label
	Private EditText2 As EditText
	Private Label3 As Label
	Private Label4 As Label
	Private Label5 As Label
	Private EditText3 As EditText
	Private EditText4 As EditText
	Private Button1 As Button
	Private ImageView1 As ImageView
	Private Button2 As Button
	
	Public inventario(6,200) As String
	
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("iniciar")
	
	
	Do While inventario(2,1)=""
	Leer_inventario
	Log("estoy leyendo")
	Sleep(3000)
	Loop
	
	
   
	' Llamar a la función para imprimir los datos en el Panel
	PrintDataToPanel(inventario)
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub


Private Sub Button2_Click
	
End Sub

Private Sub Button1_Click
	
End Sub



Sub Leer_inventario
	Try
		Dim PageServer As String = "electronicaunicesar.com.co/c0m3l0n@_3xpr355.php"
		Dim js As HttpJob
		js.Initialize("", Me)
		js.download2(PageServer, Array As String ("act", "Rall"))
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
								
					N1= Fila.Get("N")
					inventario(1,i) = Fila.Get("N")
					inventario(2,i) = Fila.Get("Nombre")
					inventario(3,i) = Fila.Get("valor_bruto")
					inventario(4,i) =  Fila.Get("Valor_neto")
					inventario(5,i) =  Fila.Get("FECHA")
					
					'Log(N1 &" "& inventario(2,N1)&" "& inventario(3,N1)&" "& inventario(4,N1) &" "& inventario(5,N1))
					
				Next
			End If
		End If
	Catch
		Log(LastException)
	End Try
End Sub

Sub PrintDataToPanel(data(,) As String)
	' Limpiar el Panel antes de agregar nuevos datos
	'Panel1.RemoveAllViews
   '' Log("entre")
	' Obtener el número de filas y columnas de la matriz
	Dim numRows As Int = data.Length
	Dim numCols As Int = 6
    
	' Configurar el tamaño de cada celda
	Dim cellWidth As Int = Panel1.Width / numCols
	Dim cellHeight As Int = Panel1.Height / numRows
	
    
	' Recorrer las filas de la matriz
	For i = 0 To numRows - 1
		' Recorrer las columnas de la matriz
		For j = 0 To numCols - 1
			
			' Crear una nueva etiqueta para cada elemento de la matriz
			Dim label As Label
			label.Initialize("label")
			If j=1 Then
				label.Width =  5%x
				label.Height = cellHeight
				label.Left = 3%x
				label.Top = i * cellHeight + 10%y
			else If j=2 Then
				label.Width =  33%x
				label.Height = cellHeight
				label.Left = j * 4%x
				label.Top = i * cellHeight+ 10%y
			
			else If j=3 Then
				label.Width =  12%x
				label.Height = cellHeight
				label.Left = j * 12%x
				label.Top = i * cellHeight+ 10%y
			
			else If j=4 Then
				label.Width =  12%x
				label.Height = cellHeight
				label.Left = j * 12%x
				label.Top = i * cellHeight+ 10%y
			else If j=5 Then
				label.Width =  38%x
				label.Height = cellHeight
				label.Left = j * 12%x
				label.Top = i * cellHeight+ 10%y
			
			Else
				label.Width = cellWidth
				label.Height = cellHeight
				label.Left = j * cellWidth
				label.Top = i * cellHeight
            		
            End If
			' Configurar el tamaño y posición de la etiqueta
			
			' Configurar el contenido de la etiqueta con el dato actual
			label.Text = data(j, i)
			'Log("valor=" & inventario(i, j))
            
			' Agregar la etiqueta al Panel
			'Panel1.AddView(label, label.Left, label.Top, label.Width, label.Height)
		Next
	Next
End Sub
