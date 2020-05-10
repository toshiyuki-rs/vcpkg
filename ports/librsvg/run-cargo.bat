@echo off
setlocal
set Path=%Path%;%USERPROFILE%\.cargo\bin
cargo %*

REM /* vi: se ts=2 sw=2 et: */
