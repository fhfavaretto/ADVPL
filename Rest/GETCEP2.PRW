#INCLUDE "protheus.ch"

User function GETCEP()
Local lRet := .t.
Local oJson


oJson := u_zViaCep(m->a1_cep)

If ValType(oJson['cep']) == "U"
	lRet := .f.
	msginfo(oJson['erro'],"Error")
Else
      //m->a1_cep := oJson['cep']
	M->A1_END := oJson['logradouro']
	//m->a1_compl := oJson['complemento']
	M->A1_BAIRRO := oJson['bairro']
	M->A1_MUN := oJson['localidade']
	M->A1_EST := oJson['uf']
	M->A1_COD_MUN := oJson['ibge']
      //oJson['gia']
      //oJson['ddd']
      //oJson['siafi']
Endif

Return lRet
