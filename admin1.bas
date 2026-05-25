B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=13.4
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: False
	#IncludeTitle: True
#End Region

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.

End Sub

Sub Globals

	Private Button_crear As Button
	Private Button_Informe As Button
	Private Button_descargar As Button
	Private Button_fallas As Button
	Private Button_estadistica As Button
	Private Button_uso As Button
	'Private Button_Modificar_Usuarios As Button

End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	'Activity.LoadLayout("Layout1")

End Sub

Sub Activity_Resume
	Activity.LoadLayout("admin")
End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub


Private Sub Button_Informe_Click
	StartActivity(ver_datos)
End Sub

Private Sub Button_crear_Click
	StartActivity(crear_usuario)
End Sub
Private Sub Button_fallas_Click

	ToastMessageShow("Módulo fallas", False)

End Sub
Private Sub Button_estadistica_Click

	VerEstadisticas

End Sub
Sub VerEstadisticas

	Dim job As HttpJob
	job.Initialize("", Me)
	
	' ← AGREGAR ESTA LÍNEA (IMPORTANTE):
	job.GetRequest.SetHeader("Authorization", "900.325.355-1")
	
	job.Download("https://araucariasolar.org/maquinas_api.php?act=stats")

	Wait For (job) JobDone(job As HttpJob)

	Button_descargar.Enabled = True

	If job.Success Then

		Dim respuesta As String = job.GetString
		Log("Respuesta stats: " & respuesta)

		Dim parser As JSONParser
		parser.Initialize(respuesta)

		' CAMBIAR ESTO:
		' Dim root As Map = parser.NextObject
		
		' POR ESTO:
		Dim lista As List = parser.NextArray  ' ← Ahora es un ARRAY, no un objeto

		For Each item As Map In lista
			Log("Máquina: " & item.Get("nombre"))
			Log("Fallas: " & item.Get("total_fallas"))
		Next

		ToastMessageShow("Estadísticas cargadas", False)

	Else

		ToastMessageShow("Error: " & job.ErrorMessage, True)

	End If

	job.Release

End Sub
Private Sub Button_uso_Click

	ToastMessageShow("Historial de uso", False)

End Sub

'Private Sub Button_modificar_Click

	'ToastMessageShow("Modificar usuarios", False)

'End Sub

