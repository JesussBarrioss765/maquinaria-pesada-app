B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=13.4
@EndOfDesignText@
#Region  Activity Attributes 
    #FullScreen: true
    #IncludeTitle: False
#End Region

Sub Process_Globals
End Sub

Sub Globals
	Private ListView_datos As ListView
	Private Button_descargar As Button
	Private Button_volver As Button
	Private Label_estado As Label

	Private URL_LISTAR As String = "https://araucariasolar.org/listar_archivos.php"
	Private TOKEN_API As String = "900.325.355-1"
End Sub

Sub Activity_Create(FirstTime As Boolean)
	Activity.LoadLayout("listado")

	Label_estado.Text = "Presiona descargar para consultar los datos"
	Button_descargar.Text = "Descargar datos"
	Button_volver.Text = "Volver"

	ListView_datos.Clear

	'Descarga automática al abrir el layout
	DescargarDatos
End Sub

Sub Activity_Resume
End Sub

Sub Activity_Pause (UserClosed As Boolean)
End Sub

Private Sub Button_descargar_Click
	DescargarDatos
End Sub

Private Sub Button_volver_Click
	Activity.Finish
End Sub

Sub DescargarDatos
	Try
		Label_estado.Text = "Consultando datos..."
		Button_descargar.Enabled = False
		ListView_datos.Clear

		Dim job As HttpJob
		job.Initialize("listar", Me)

		job.Download(URL_LISTAR)
		job.GetRequest.SetHeader("Authorization", TOKEN_API)

		Wait For (job) JobDone(job As HttpJob)

		Button_descargar.Enabled = True

		If job.Success Then
			Dim respuesta As String = job.GetString
			Log("Respuesta listar: " & respuesta)

			Dim parser As JSONParser
			parser.Initialize(respuesta)

			Dim root As Map = parser.NextObject

			Dim ok As Boolean = root.Get("ok")
			Dim mensaje As String = root.Get("mensaje")

			If ok Then
				Dim total As Int = root.Get("total")
				Dim datos As List = root.Get("datos")

				Label_estado.Text = "Registros encontrados: " & total

				If datos.Size = 0 Then
					ListView_datos.AddSingleLine("No hay registros guardados.")
					job.Release
					Return
				End If

				For i = 0 To datos.Size - 1
					Dim fila As Map = datos.Get(i)

					Dim id As String = ObtenerValor(fila, "id")
					Dim codigo As String = ObtenerValor(fila, "codigo")
					Dim nombre As String = ObtenerValor(fila, "nombre")
					Dim cantidad As String = ObtenerValor(fila, "cantidad")
					Dim precio As String = ObtenerValor(fila, "precio")
					Dim unidad As String = ObtenerValor(fila, "unidad")
					Dim proyecto As String = ObtenerValor(fila, "proyecto")
					Dim fecha As String = ObtenerValor(fila, "fecha_subida")
					Dim url As String = ObtenerValor(fila, "url_publica")

					Dim texto As String
					texto = "ID: " & id & CRLF & _
                            "Código: " & codigo & CRLF & _
                            "Nombre: " & nombre & CRLF & _
                            "Cantidad: " & cantidad & " " & unidad & CRLF & _
                            "Precio: " & precio & CRLF & _
                            "Proyecto: " & proyecto & CRLF & _
                            "Fecha: " & fecha & CRLF & _
                            "Tocar este registro para ver la foto"

					'Aquí se guarda la URL como valor oculto del item.
					'Cuando el usuario toque el registro, se abre esa URL en el navegador.
					ListView_datos.AddTwoLines2(nombre, texto, url)
				Next

			Else
				Label_estado.Text = "Error: " & mensaje
				MsgboxAsync(mensaje, "Error del servidor")
			End If

		Else
			Label_estado.Text = "Error HTTP: " & job.ErrorMessage
			MsgboxAsync("No se pudo consultar el servidor." & CRLF & job.ErrorMessage, "Error HTTP")
		End If

		job.Release

	Catch
		Button_descargar.Enabled = True
		Label_estado.Text = "Error inesperado"
		Log(LastException)
		MsgboxAsync("Ocurrió un error inesperado descargando los datos.", "Error")
	End Try
End Sub

Sub ObtenerValor(m As Map, clave As String) As String
	If m.ContainsKey(clave) = False Then Return ""

	Dim v As Object = m.Get(clave)

	If v = Null Then Return ""

	Return v
End Sub

Private Sub ListView_datos_ItemClick (Position As Int, Value As Object)
	Try
		Dim url As String = Value

		If url.Trim <> "" Then
			Dim p As PhoneIntents
			StartActivity(p.OpenBrowser(url))
		Else
			ToastMessageShow("Este registro no tiene foto asociada", True)
		End If

	Catch
		Log(LastException)
		ToastMessageShow("No se pudo abrir la foto", True)
	End Try
End Sub