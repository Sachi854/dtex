@echo off
set cd=
FOR /F %%i in ('cd') DO @SET cd=%%i

docker run --rm --mount type=bind,source=%cd%,target=/workdir --mount type=volume,source=ltcache,target=/usr/local/texlive/2020/texmf-var/luatex-cache sachi854/dtex:latest %*