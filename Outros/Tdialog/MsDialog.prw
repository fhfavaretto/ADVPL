#include "TOTVS.CH"

User Function MSDialog()
  // Cria diálogo
 // MsDialog():New( [ nTop ], [ nLeft ], [ nBottom ], [ nRight ], [ cCaption ], [ uParam6 ], [ uParam7 ], [ uParam8 ], [ uParam9 ], [ nClrText ], [ nClrBack ], [ uParam12 ], [ oWnd ], [ lPixel ], [ uParam15 ], [ uParam16 ], [ uParam17 ], [ lTransparent ] )

  Local oDlg := MSDialog():New(180,180,550,700,'Exemplo MSDialog',,,,,CLR_BLACK,CLR_WHITE,,,.T.)

  // Ativa diálogo centralizado
  oDlg:Activate(,,,.T.,{||,.T.},,{||} )
Return
