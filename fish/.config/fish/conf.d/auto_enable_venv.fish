function __auto_venv --on-variable PWD --description "Ativação automática de venv Python"
    # Status: 0 = nada feito, 1 = venv ativado agora
    set -l venv_found 0

    # Nomes comuns de pastas de venv. Adicione outros se usar nomes diferentes.
    set -l venv_names ".venv" venv env

    # 1. Tenta encontrar um venv na pasta ATUAL
    for vname in $venv_names
        if test -f "$PWD/$vname/bin/activate.fish"
            # Se achou, verifica se JÁ está ativo para não reativar à toa
            if test "$VIRTUAL_ENV" != "$PWD/$vname"
                source "$PWD/$vname/bin/activate.fish"
            end
            set venv_found 1
            break
        end
    end

    # 2. Se não achou venv na pasta atual, decide se mantém o anterior ou desativa
    if test $venv_found -eq 0
        if set -q VIRTUAL_ENV
            # Descobre a raiz do projeto do venv atual (remove a pasta do venv do caminho)
            set -l venv_root (string replace -r '/[^/]+$' '' "$VIRTUAL_ENV")

            # Verifica se a pasta atual ($PWD) ainda está dentro da raiz do projeto
            # Se PWD começa com venv_root, estamos numa subpasta -> MANTER ATIVO
            if string match -q "$venv_root*" "$PWD"
                return
            else
                # Se saímos da árvore do projeto -> DESATIVAR
                deactivate
            end
        end
    end
end

# Executa uma vez ao iniciar o terminal para checar a pasta onde você abriu
__auto_venv
