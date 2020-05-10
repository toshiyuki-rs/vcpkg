@echo off
setlocal
set Path=%Path%;%USERPROFILE%\.cargo\bin
rustup %*

REM /* vi: se ts=2 sw=2 et: */
