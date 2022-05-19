#INCLUDE "protheus.ch"

User function getcep(nCampo)

	Local qRet
	Local oJson

	oJson := u_zViaCep(m->a1_cep)

	If ValType(oJson['cep']) == "U"
		lRet := .f.
		msginfo(oJson['erro'],"Error")
	Else
		//m->a1_cep := oJson['cep']
		if nCampo == 1
			qRet := oJson['logradouro'] 	//m->a1_end := oJson['logradouro']
		elseif nCampo == 2
			//m->a1_compl := oJson['complemento']
			qRet := oJson['bairro'] 		//m->a1_bairro := oJson['bairro']
		elseif nCampo == 3
			qRet := oJson['localidade']	//m->a1_mun := oJson['localidade']
		elseif nCampo == 4
			qRet := oJson['uf']			//m->a1_est := oJson['uf']
		elseif nCampo == 5
			qRet := oJson['ibge']		//m->a1_cod_mun := oJson['ibge']
		endif
		//oJson['gia']
		//oJson['ddd']
		//oJson['siafi']
	Endif

Return qRet
