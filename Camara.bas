B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=10.7
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: true
	#IncludeTitle: False
#End Region

Sub Process_Globals
	Private frontCamera As Boolean = False
	Private detector As JavaObject
	Private SearchForBarcodes As Boolean
	Private LastPreview As Long
	Private IntervalBetweenPreviewsMs As Int = 100
	
	Public nom, cant, un, costo As String
	Public cantidad_resultante As Int
	
	Private CC As ContentChooser

	Dim camActiva As Boolean = True
End Sub

Sub Globals
	Private Panel1 As Panel
	Private camEx As CameraExClass
	Private pnlDrawing As Panel
	Private cvs As B4XCanvas
	
	Private EditText_unidad As EditText
	Private Button_registrar As Button
	Private Label5 As Label
	Private Label4 As Label
	Private EditText_cantidad As EditText
	Private EditText_nombre As EditText
	Private Label3 As Label
	Private Label2 As Label
	Private EditText_codigo As EditText
	Private Button_buscar As Button
	Private Label1 As Label
	Private Button_inhabilitar As Button
	Private EditText_agregar As EditText
	Private Button_agregar As Button

	Private ImageView1 As ImageView
	Private btnTakePicture As Button
	Private btnEffect As Button
	Private btnChangeCamera As Button
	Private btnFlash As Button
	Private btnPictureSize As Button
	Private btnFocus As Button
	Private SeekBar1 As SeekBar
	Private Label6 As Label
	Private Label7 As Label
	Private EditText_precio As EditText
	Private ImageView2 As ImageView
	
	Private RutaTemporal As String
	Private NombreTemporal As String

	Private USUARIO_ID As String = "1"
	Private PROYECTO As String = "prueba"
	Private TOKEN_API As String = "900.325.355-1"
	Private URL_UPLOAD As String = "https://araucariasolar.org/upload.php"
	
	Private btnSeleccionarFoto As Button
	Private lblEstado As Label
	Private btnSubirFoto As Button
	Private imgPreview As ImageView
End Sub

Sub Activity_Create(FirstTime As Boolean)
	Activity.LoadLayout("2")
	
	If FirstTime Then
		CreateDetector(Array("ALL_FORMATS"))
	End If
	
	cvs.Initialize(pnlDrawing)
	
	Label1.TextSize = Mod1.Scale_Font(20)
	Label2.TextSize = Mod1.Scale_Font(15)
	Label3.TextSize = Mod1.Scale_Font(15)
	Label4.TextSize = Mod1.Scale_Font(15)
	Label5.TextSize = Mod1.Scale_Font(15)
	Label6.TextSize = Mod1.Scale_Font(15)
	Label7.TextSize = Mod1.Scale_Font(15)
	lblEstado.TextSize = Mod1.Scale_Font(12)
		
	EditText_agregar.TextSize = Mod1.Scale_Font(14)
	EditText_cantidad.TextSize = Mod1.Scale_Font(14)
	EditText_codigo.TextSize = Mod1.Scale_Font(14)
	EditText_unidad.TextSize = Mod1.Scale_Font(14)
	EditText_nombre.TextSize = Mod1.Scale_Font(14)
	EditText_precio.TextSize = Mod1.Scale_Font(14)
	
	Button_agregar.TextSize = Mod1.Scale_Font(15)
	Button_buscar.TextSize = Mod1.Scale_Font(15)
	Button_inhabilitar.TextSize = Mod1.Scale_Font(15)
	Button_registrar.TextSize = Mod1.Scale_Font(15)
	btnFlash.TextSize = Mod1.Scale_Font(15)
	
	btnSeleccionarFoto.TextSize = Mod1.Scale_Font(15)
	btnSubirFoto.TextSize = Mod1.Scale_Font(15)
	
	CC.Initialize("CC")

	RutaTemporal = ""
	NombreTemporal = ""

	lblEstado.Text = "Sin foto seleccionada"
	btnSubirFoto.Enabled = False
	
	imgPreview.Visible = False
	imgPreview.Enabled = False
	
	'El código NO se escribe manualmente, lo detecta la cámara
	EditText_codigo.Enabled = False
	
	'Bloquea todos los campos hasta detectar un código válido
	BloquearCamposSegunCodigo
	
	If camActiva Then
		Button_inhabilitar.Text = "OFF cam"
	Else
		Button_inhabilitar.Text = "ON cam"
	End If
End Sub

Private Sub CreateDetector(Codes As List)
	Dim ctxt As JavaObject
	ctxt.InitializeContext
	
	Dim builder As JavaObject
	builder.InitializeNewInstance("com/google/android/gms/vision/barcode/BarcodeDetector.Builder".Replace("/", "."), Array(ctxt))
	
	Dim barcodeClass As String = "com/google/android/gms/vision/barcode/Barcode".Replace("/", ".")
	Dim barcodeStatic As JavaObject
	barcodeStatic.InitializeStatic(barcodeClass)
	
	Dim format As Int
	For Each formatName As String In Codes
		format = Bit.Or(format, barcodeStatic.GetField(formatName))
	Next
	
	builder.RunMethod("setBarcodeFormats", Array(format))
	detector = builder.RunMethod("build", Null)
	
	Dim operational As Boolean = detector.RunMethod("isOperational", Null)
	Log("Is detector operational: " & operational)
	SearchForBarcodes = operational
End Sub

Sub Activity_Resume
	If camActiva Then
		InitializeCamera
	End If
End Sub

Private Sub InitializeCamera
	If camActiva = False Then Return
	
	Starter.rp.CheckAndRequest(Starter.rp.PERMISSION_CAMERA)
	Wait For Activity_PermissionResult (Permission As String, Result As Boolean)
	
	If camActiva = False Then Return
	
	If Result Then
		camEx.Initialize(Panel1, frontCamera, Me, "Camera1")
		frontCamera = camEx.Front
	Else
		ToastMessageShow("Permiso de cámara denegado.", True)
	End If
End Sub

Sub Activity_Pause(UserClosed As Boolean)
	If camEx.IsInitialized Then
		camEx.Release
	End If
End Sub

Sub Camera1_Ready(Success As Boolean)
	If camActiva = False Then
		If camEx.IsInitialized Then camEx.Release
		Return
	End If
	
	If Success Then
		camEx.SetJpegQuality(90)
		camEx.SetContinuousAutoFocus
		camEx.CommitParameters
		camEx.StartPreview
	Else
		ToastMessageShow("Cannot open camera.", True)
	End If
End Sub

Sub Camera1_Preview(data() As Byte)
	If camActiva = False Then Return
	If SearchForBarcodes = False Then Return
	
	If DateTime.Now > LastPreview + IntervalBetweenPreviewsMs Then
		cvs.ClearRect(cvs.TargetRect)
		
		Dim frameBuilder As JavaObject
		Dim bb As JavaObject
		bb = bb.InitializeStatic("java.nio.ByteBuffer").RunMethod("wrap", Array(data))
		
		frameBuilder.InitializeNewInstance("com/google/android/gms/vision/Frame.Builder".Replace("/", "."), Null)
		Dim cs As CameraSize = camEx.GetPreviewSize
		frameBuilder.RunMethod("setImageData", Array(bb, cs.Width, cs.Height, 842094169))
		
		Dim frame As JavaObject = frameBuilder.RunMethod("build", Null)
		Dim SparseArray As JavaObject = detector.RunMethod("detect", Array(frame))
		
		LastPreview = DateTime.Now
		Dim Matches As Int = SparseArray.RunMethod("size", Null)
		
		For i = 0 To Matches - 1
			Dim barcode As JavaObject = SparseArray.RunMethod("valueAt", Array(i))
			Dim raw As String = barcode.GetField("rawValue")
			raw = raw.Trim
			
			Log(raw)
			
			If CodigoPermitido(raw) Then
				EditText_codigo.Text = raw
				BloquearCamposSegunCodigo
				
				ToastMessageShow("Código válido detectado: " & raw, False)
				
				'Detiene la lectura para que no siga pitando y sobrescribiendo
				SearchForBarcodes = False
			Else
				EditText_codigo.Text = ""
				BloquearCamposSegunCodigo
				
				ToastMessageShow("Código no reconocido", False)
			End If
			
			Dim points() As Object = barcode.GetField("cornerPoints")
			Dim tl As JavaObject = points(0)
			Dim br As JavaObject = points(2)
			Dim r As B4XRect
			
			Dim size As CameraSize = camEx.GetPreviewSize
			Dim xscale, yscale As Float
			
			If camEx.PreviewOrientation Mod 180 = 0 Then
				xscale = Panel1.Width / size.Width
				yscale = Panel1.Height / size.Height
				r.Initialize(tl.GetField("x"), tl.GetField("y"), br.GetField("x"), br.GetField("y"))
			Else
				xscale = Panel1.Width / size.Height
				yscale = Panel1.Height / size.Width
				r.Initialize(br.GetField("y"), br.GetField("x"), tl.GetField("y"), tl.GetField("x"))
			End If
			
			Select camEx.PreviewOrientation
				Case 180
					r.Initialize(size.Width - r.Right, size.Height - r.Bottom, size.Width - r.Left, size.Height - r.Top)
				Case 90
					r.Initialize(size.Height - r.Right, r.Top, size.Height - r.Left, r.Bottom)
			End Select
			
			r.Left = r.Left * xscale
			r.Right = r.Right * xscale
			r.Top = r.Top * yscale
			r.Bottom = r.Bottom * yscale
			
			cvs.DrawRect(r, Colors.Red, False, 5dip)
		Next
		
		If Matches = 0 Then
			cvs.ClearRect(cvs.TargetRect)
		End If
		
		cvs.Invalidate
	End If
End Sub

Sub CodigoPermitido(raw As String) As Boolean
	raw = raw.Trim
	
	If raw = "GSTM0182430522" Or _
	   raw = "GSTM0182320116" Or _
	   raw = "GSTM0182310317" Or _
	   raw = "GSTM0161310213" Or _
	   raw = "GSTM1161360421" Then
		Return True
	End If
	
	Return False
End Sub

Sub BloquearCamposSegunCodigo
	Dim activo As Boolean
	activo = EditText_codigo.Text.Trim <> ""
	
	EditText_nombre.Enabled = activo
	EditText_cantidad.Enabled = activo
	EditText_unidad.Enabled = activo
	EditText_precio.Enabled = activo
	EditText_agregar.Enabled = activo
	
	Button_buscar.Enabled = activo
	Button_registrar.Enabled = activo
	Button_agregar.Enabled = activo
	
	btnSeleccionarFoto.Enabled = activo
	
	If activo = False Then
		btnSubirFoto.Enabled = False
	End If
End Sub

Sub Camera1_PictureTaken(Data() As Byte)
End Sub

Sub EncenderCamara
	camActiva = True
	SearchForBarcodes = True
	
	Panel1.Visible = True
	Panel1.Enabled = True
	pnlDrawing.Visible = True
	pnlDrawing.Enabled = True
	
	imgPreview.Visible = False
	imgPreview.Enabled = False
	
	Button_inhabilitar.Text = "OFF cam"
	
	If camEx.IsInitialized = False Then
		InitializeCamera
	Else
		Try
			camEx.StartPreview
		Catch
			Log(LastException)
			InitializeCamera
		End Try
	End If
End Sub

Sub ApagarCamara
	camActiva = False
	SearchForBarcodes = False
	
	cvs.ClearRect(cvs.TargetRect)
	cvs.Invalidate
	
	If camEx.IsInitialized Then
		camEx.Release
	End If
	
	Panel1.Visible = False
	Panel1.Enabled = False
	pnlDrawing.Visible = False
	pnlDrawing.Enabled = False
	
	imgPreview.Visible = True
	imgPreview.Enabled = True
	
	Button_inhabilitar.Text = "ON cam"
End Sub

Sub ChangeCamera_Click
	If camEx.IsInitialized Then
		camEx.Release
	End If
	frontCamera = Not(frontCamera)
	If camActiva Then
		InitializeCamera
	End If
End Sub

Sub btnEffect_Click
	If camEx.IsInitialized = False Then Return
	
	Dim effects As List = camEx.GetSupportedColorEffects
	If effects.IsInitialized = False Then
		ToastMessageShow("Effects not supported.", False)
		Return
	End If
	
	Dim effect As String = effects.Get((effects.IndexOf(camEx.GetColorEffect) + 1) Mod effects.Size)
	camEx.SetColorEffect(effect)
	ToastMessageShow(effect, False)
	camEx.CommitParameters
End Sub

Sub btnFlash_Click
	If camEx.IsInitialized = False Then Return
	
	Dim f() As Float = camEx.GetFocusDistances
	Log(f(0) & ", " & f(1) & ", " & f(2))
	
	Dim flashModes As List = camEx.GetSupportedFlashModes
	If flashModes.IsInitialized = False Then
		ToastMessageShow("Flash not supported.", False)
		Return
	End If
	
	Dim flash As String = flashModes.Get((flashModes.IndexOf(camEx.GetFlashMode) + 1) Mod flashModes.Size)
	camEx.SetFlashMode(flash)
	ToastMessageShow(flash, False)
	camEx.CommitParameters
End Sub

Sub btnPictureSize_Click
	If camEx.IsInitialized = False Then Return
	
	Dim pictureSizes() As CameraSize = camEx.GetSupportedPicturesSizes
	Dim current As CameraSize = camEx.GetPictureSize
	
	For i = 0 To pictureSizes.Length - 1
		If pictureSizes(i).Width = current.Width And pictureSizes(i).Height = current.Height Then Exit
	Next
	
	Dim ps As CameraSize = pictureSizes((i + 1) Mod pictureSizes.Length)
	camEx.SetPictureSize(ps.Width, ps.Height)
	ToastMessageShow(ps.Width & "x" & ps.Height, False)
	camEx.CommitParameters
End Sub

Sub SeekBar1_ValueChanged(Value As Int, UserChanged As Boolean)
	If UserChanged = False Then Return
	If camEx.IsInitialized = False Then Return
	If camEx.IsZoomSupported = False Then Return
	
	camEx.Zoom = Value / 100 * camEx.GetMaxZoom
	camEx.CommitParameters
End Sub

'////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
' INVENTARIO
'////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Private Sub Button_buscar_Click
	If EditText_codigo.Text.Trim = "" Then
		MsgboxAsync("Primero debes detectar un código válido con la cámara.", "Código faltante")
		Return
	End If
	
	leer_inventario
End Sub

Private Sub Button_registrar_LongClick
	If ValidarDatosProducto = False Then Return
	Guadar_datos
End Sub

Private Sub Button_inhabilitar_Click
	If camActiva Then
		ApagarCamara
	Else
		EncenderCamara
	End If
End Sub

Sub Guadar_datos
	Try
		Dim PageServer As String = "electronicaunicesar.com.co/c0m3l0n@_3xpr355.php"
		Dim js As HttpJob
		js.Initialize("", Me)
		js.Download2(PageServer, Array As String( _
			"act", "Nin", _
			"COD", EditText_codigo.Text.Trim, _
			"NOM", EditText_nombre.Text.Trim, _
			"CANT", EditText_cantidad.Text.Trim, _
			"UN", EditText_unidad.Text.Trim, _
			"PRECIO", EditText_precio.Text.Trim))

		Wait For (js) JobDone(js As HttpJob)
		
		If js.Success Then
			Dim res As String = js.GetString
			Dim parser As JSONParser
			parser.Initialize(res)
			
			If res <> False Then
				Dim Tabla As List = parser.NextArray
				
				If Tabla.Get(0) = 0 Then
					ToastMessageShow("Datos ingresados, producto registrado", False)
				Else
					MsgboxAsync("El producto ya ha sido registrado o verifique su conexión a internet", "Error")
				End If
			End If
		Else
			MsgboxAsync("No se pudo registrar el producto. Revise la conexión.", "Error")
		End If
		
		js.Release
		
	Catch
		Log(LastException)
		MsgboxAsync("Error inesperado al guardar los datos.", "Error")
	End Try
End Sub

Sub leer_inventario
	Try
		Dim PageServer As String = "electronicaunicesar.com.co/c0m3l0n@_3xpr355.php"
		Dim js As HttpJob
		js.Initialize("", Me)
		js.Download2(PageServer, Array As String("act", "Bs", "CODI", EditText_codigo.Text.Trim))
	
		Wait For (js) JobDone(js As HttpJob)
		
		If js.Success Then
			Dim res As String = js.GetString
			Dim parser As JSONParser
			parser.Initialize(res)
			
			If res <> False Then
				Dim Tabla As List = parser.NextArray
				
				If Tabla.Size = 0 Then
					ToastMessageShow("No se encontró producto con ese código", True)
					Return
				End If
				
				Dim Fila As Map
				
				For i = 0 To Tabla.Size - 1
					Fila = Tabla.Get(i)
					ToastMessageShow("Dato encontrado", False)
					
					nom = Fila.Get("Nombre")
					cant = Fila.Get("Cantidad")
					un = Fila.Get("Unidades")
					costo = Fila.Get("Costo")
					
					EditText_nombre.Text = nom
					EditText_cantidad.Text = cant
					EditText_unidad.Text = un
					EditText_precio.Text = costo
				Next
			End If
		Else
			MsgboxAsync("No se pudo consultar el inventario. Revise la conexión.", "Error")
		End If
		
		js.Release
		
	Catch
		Log(LastException)
		MsgboxAsync("Error inesperado al consultar inventario.", "Error")
	End Try
End Sub

Sub act_cant
	Try
		Dim PageServer As String = "electronicaunicesar.com.co/c0m3l0n@_3xpr355.php"
		Dim js As HttpJob
		js.Initialize("", Me)
		js.Download2(PageServer, Array As String( _
			"act", "Act_cantidad", _
			"CODIG1", EditText_codigo.Text.Trim, _
			"CANTIDAD1", cantidad_resultante))

		Wait For (js) JobDone(js As HttpJob)
		
		If js.Success Then
			Dim res As String = js.GetString
			Dim parser As JSONParser
			parser.Initialize(res)
			
			If res <> False Then
				Dim Tabla As List = parser.NextArray
				
				If Tabla.Get(0) = 0 Then
					ToastMessageShow("Producto actualizado", False)
				Else
					MsgboxAsync("El producto ya ha sido registrado o verifique su conexión a internet", "Error")
				End If
			End If
		Else
			MsgboxAsync("No se pudo actualizar la cantidad. Revise la conexión.", "Error")
		End If
		
		js.Release
		
	Catch
		Log(LastException)
		MsgboxAsync("Error inesperado al actualizar cantidad.", "Error")
	End Try
End Sub

Private Sub Button_agregar_Click
	If EditText_codigo.Text.Trim = "" Then
		MsgboxAsync("Primero debes detectar un código válido con la cámara.", "Código faltante")
		Return
	End If
	
	If EditText_cantidad.Text.Trim = "" Then
		MsgboxAsync("Primero debes consultar o ingresar la cantidad actual.", "Cantidad faltante")
		EditText_cantidad.RequestFocus
		Return
	End If
	
	If EditText_agregar.Text.Trim = "" Then
		MsgboxAsync("Debes ingresar la cantidad que vas a agregar.", "Cantidad faltante")
		EditText_agregar.RequestFocus
		Return
	End If
	
	If IsNumber(NormalizarNumero(EditText_cantidad.Text.Trim)) = False Then
		MsgboxAsync("La cantidad actual debe ser numérica.", "Dato inválido")
		EditText_cantidad.RequestFocus
		Return
	End If
	
	If IsNumber(NormalizarNumero(EditText_agregar.Text.Trim)) = False Then
		MsgboxAsync("La cantidad a agregar debe ser numérica.", "Dato inválido")
		EditText_agregar.RequestFocus
		Return
	End If
	
	cantidad_resultante = EditText_agregar.Text.Trim + EditText_cantidad.Text.Trim
	
	act_cant
	
	EditText_agregar.Text = ""
	EditText_cantidad.Text = ""
	leer_inventario
End Sub

'////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
' FOTOS Y SUBIDA AL SERVIDOR
'////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Sub btnSeleccionarFoto_Click
	Try
		If EditText_codigo.Text.Trim = "" Then
			MsgboxAsync("Primero debes detectar un código válido con la cámara.", "Código faltante")
			Return
		End If
		
		lblEstado.Text = "Abriendo galería..."
		
		If camActiva Then
			ApagarCamara
		End If
		
		imgPreview.Visible = True
		imgPreview.Enabled = True
		
		CC.Show("image/*", "Selecciona una imagen")
	Catch
		Log(LastException)
		lblEstado.Text = "Error al abrir galería"
		ToastMessageShow("No se pudo abrir la galería", True)
	End Try
End Sub

Sub CC_Result(Success As Boolean, Dir As String, FileName As String)
	Try
		If Success = False Then
			lblEstado.Text = "Selección cancelada"
			btnSubirFoto.Enabled = False
			Return
		End If

		Log("Dir recibido: " & Dir)
		Log("FileName recibido: " & FileName)

		Dim extension As String = ObtenerExtension(FileName)
		If extension = "" Then extension = ".jpg"

		NombreTemporal = "foto_" & DateTime.Now & extension
		RutaTemporal = File.DirInternal

		Dim In As InputStream
		Dim Out As OutputStream

		In = File.OpenInput(Dir, FileName)
		Out = File.OpenOutput(RutaTemporal, NombreTemporal, False)

		File.Copy2(In, Out)

		In.Close
		Out.Close

		imgPreview.Bitmap = LoadBitmapSample(RutaTemporal, NombreTemporal, imgPreview.Width, imgPreview.Height)
		lblEstado.Text = "Foto lista: " & NombreTemporal
		
		If EditText_codigo.Text.Trim <> "" Then
			btnSubirFoto.Enabled = True
		Else
			btnSubirFoto.Enabled = False
		End If

		ToastMessageShow("Imagen cargada correctamente", False)

	Catch
		Log(LastException)
		lblEstado.Text = "Error al cargar imagen"
		btnSubirFoto.Enabled = False
		ToastMessageShow("No se pudo procesar la imagen seleccionada", True)
	End Try
End Sub

Sub btnSubirFoto_Click
	If RutaTemporal = "" Or NombreTemporal = "" Then
		MsgboxAsync("Primero debes seleccionar una foto antes de subir.", "Foto faltante")
		Return
	End If

	If ValidarDatosAntesDeSubir = False Then Return

	SubirFoto(RutaTemporal, NombreTemporal, USUARIO_ID, PROYECTO)
End Sub

Sub SubirFoto(DirArchivo As String, NombreArchivoLocal As String, UsuarioIdLocal As String, ProyectoLocal As String)
	Try
		btnSubirFoto.Enabled = False
		btnSeleccionarFoto.Enabled = False
		lblEstado.Text = "Subiendo foto y datos..."

		Dim job As HttpJob
		job.Initialize("upload", Me)

		Dim fd As MultipartFileData
		fd.Initialize
		fd.Dir = DirArchivo
		fd.FileName = NombreArchivoLocal
		fd.KeyName = "archivo"
		fd.ContentType = ObtenerMimeType(NombreArchivoLocal)

		Dim datos As Map
		datos.Initialize

		datos.Put("usuario_id", UsuarioIdLocal)
		datos.Put("proyecto", ProyectoLocal)

		'Estos datos se guardan en la base de datos junto con la foto
		datos.Put("codigo", EditText_codigo.Text.Trim)
		datos.Put("nombre", EditText_nombre.Text.Trim)
		datos.Put("cantidad", NormalizarNumero(EditText_cantidad.Text.Trim))
		datos.Put("precio", NormalizarNumero(EditText_precio.Text.Trim))
		datos.Put("unidad", EditText_unidad.Text.Trim)

		job.PostMultipart(URL_UPLOAD, datos, Array As MultipartFileData(fd))
		job.GetRequest.SetHeader("Authorization", TOKEN_API)

		Wait For (job) JobDone(job As HttpJob)

		btnSeleccionarFoto.Enabled = True
		btnSubirFoto.Enabled = True

		If job.Success Then
			Dim respuesta As String = job.GetString
			Log("Respuesta servidor: " & respuesta)

			Dim parser As JSONParser
			parser.Initialize(respuesta)
			Dim root As Map = parser.NextObject

			Dim ok As Boolean = root.Get("ok")
			Dim mensaje As String = root.Get("mensaje")

			If ok Then
				Dim id As Int = root.Get("id")
				Dim url As String = root.Get("url")
				Dim nombreGuardado As String = root.Get("nombre_guardado")

				lblEstado.Text = "Subida exitosa. ID: " & id

				MsgboxAsync( _
					"Foto y datos guardados correctamente." & CRLF & CRLF & _
					"ID: " & id & CRLF & _
					"Código: " & EditText_codigo.Text.Trim & CRLF & _
					"Nombre: " & EditText_nombre.Text.Trim & CRLF & _
					"Cantidad: " & EditText_cantidad.Text.Trim & CRLF & _
					"Unidad: " & EditText_unidad.Text.Trim & CRLF & _
					"Precio: " & EditText_precio.Text.Trim & CRLF & CRLF & _
					"Nombre guardado: " & nombreGuardado & CRLF & _
					"URL: " & url, _
					"Éxito")

				LimpiarCampos

				RutaTemporal = ""
				NombreTemporal = ""

				imgPreview.Visible = False
				imgPreview.Enabled = False

				lblEstado.Text = "Sin foto seleccionada"
				btnSubirFoto.Enabled = False
				
				BloquearCamposSegunCodigo

			Else
				lblEstado.Text = "Error del servidor: " & mensaje
				MsgboxAsync(mensaje, "Error del servidor")
			End If

		Else
			lblEstado.Text = "Error HTTP: " & job.ErrorMessage
			ToastMessageShow("No se pudo subir la foto", True)
			Log("Error HTTP: " & job.ErrorMessage)

			Try
				Log("Detalle error: " & job.GetString)
			Catch
				Log(LastException)
			End Try
		End If

		job.Release

	Catch
		btnSeleccionarFoto.Enabled = True
		btnSubirFoto.Enabled = True
		Log(LastException)
		lblEstado.Text = "Error inesperado al subir"
		MsgboxAsync("Ocurrió un error inesperado al subir la foto y los datos.", "Error")
	End Try
End Sub

'////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
' VALIDACIONES Y UTILIDADES
'////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Sub ValidarDatosProducto As Boolean
	Dim faltantes As String = ""

	If EditText_codigo.Text.Trim = "" Then faltantes = faltantes & "- Código" & CRLF
	If EditText_nombre.Text.Trim = "" Then faltantes = faltantes & "- Nombre" & CRLF
	If EditText_cantidad.Text.Trim = "" Then faltantes = faltantes & "- Cantidad" & CRLF
	If EditText_unidad.Text.Trim = "" Then faltantes = faltantes & "- Unidad" & CRLF
	If EditText_precio.Text.Trim = "" Then faltantes = faltantes & "- Precio" & CRLF

	If faltantes <> "" Then
		MsgboxAsync("Faltan los siguientes datos:" & CRLF & CRLF & faltantes, "Datos faltantes")
		Return False
	End If

	If IsNumber(NormalizarNumero(EditText_cantidad.Text.Trim)) = False Then
		MsgboxAsync("La cantidad debe ser un número válido.", "Dato incorrecto")
		EditText_cantidad.RequestFocus
		Return False
	End If

	If IsNumber(NormalizarNumero(EditText_precio.Text.Trim)) = False Then
		MsgboxAsync("El precio debe ser un número válido.", "Dato incorrecto")
		EditText_precio.RequestFocus
		Return False
	End If

	Return True
End Sub

Sub ValidarDatosAntesDeSubir As Boolean
	Dim faltantes As String = ""

	If EditText_codigo.Text.Trim = "" Then faltantes = faltantes & "- Código" & CRLF
	If EditText_nombre.Text.Trim = "" Then faltantes = faltantes & "- Nombre" & CRLF
	If EditText_cantidad.Text.Trim = "" Then faltantes = faltantes & "- Cantidad" & CRLF
	If EditText_unidad.Text.Trim = "" Then faltantes = faltantes & "- Unidad" & CRLF
	If EditText_precio.Text.Trim = "" Then faltantes = faltantes & "- Precio" & CRLF
	
	If RutaTemporal = "" Or NombreTemporal = "" Then
		faltantes = faltantes & "- Foto" & CRLF
	End If

	If faltantes <> "" Then
		MsgboxAsync("Faltan los siguientes datos:" & CRLF & CRLF & faltantes, "Datos faltantes")
		Return False
	End If

	If IsNumber(NormalizarNumero(EditText_cantidad.Text.Trim)) = False Then
		MsgboxAsync("La cantidad debe ser un número válido.", "Dato incorrecto")
		EditText_cantidad.RequestFocus
		Return False
	End If

	If IsNumber(NormalizarNumero(EditText_precio.Text.Trim)) = False Then
		MsgboxAsync("El precio debe ser un número válido.", "Dato incorrecto")
		EditText_precio.RequestFocus
		Return False
	End If

	Return True
End Sub

Sub NormalizarNumero(valor As String) As String
	valor = valor.Trim
	valor = valor.Replace(",", ".")
	Return valor
End Sub

Sub ObtenerMimeType(NombreArchivo As String) As String
	Dim n As String = NombreArchivo.ToLowerCase

	If n.Contains(".jpg") Or n.Contains(".jpeg") Then
		Return "image/jpeg"
	Else If n.Contains(".png") Then
		Return "image/png"
	Else If n.Contains(".webp") Then
		Return "image/webp"
	Else
		Return "application/octet-stream"
	End If
End Sub

Sub ObtenerExtension(NombreArchivo As String) As String
	Dim n As String = NombreArchivo.ToLowerCase

	If n.Contains(".jpg") Then Return ".jpg"
	If n.Contains(".jpeg") Then Return ".jpeg"
	If n.Contains(".png") Then Return ".png"
	If n.Contains(".webp") Then Return ".webp"

	Return ""
End Sub

Sub LimpiarCampos
	EditText_codigo.Text = ""
	EditText_nombre.Text = ""
	EditText_cantidad.Text = ""
	EditText_unidad.Text = ""
	EditText_precio.Text = ""
	EditText_agregar.Text = ""
	
	BloquearCamposSegunCodigo
	
	'Permite volver a leer un nuevo código después de limpiar
	SearchForBarcodes = True
End Sub