B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=10.7
@EndOfDesignText@
'Code module
'Subs in this code module will be accessible from all modules.
Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
	Dim Title As String  = "Smd Code"
	Dim FontScale As Float
End Sub

Sub Scale_Font(font As Float) As Float
	'--- font de refrenecia 720X1280
	' relacion 0.5625
	'Dim Relacion As Float=100%x/100%y
	Dim NewFont As Float '=font*(100%x/720)*(Relacion/0.5625)
	'Return NewFont
	
	NewFont = Round2( font/FontScale,1)
	Return NewFont
End Sub

Sub GetFontScale
	Try
		Dim access As Accessiblity
		FontScale = access.GetUserFontScale
	Catch
		FontScale=1
	End Try
End Sub