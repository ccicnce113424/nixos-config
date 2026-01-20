{
  runCommand,
  chrony,
  srcOnly,
}:
runCommand "10-chrony-onoffline" { } ''
  cp ${srcOnly chrony}/examples/chrony.nm-dispatcher.onoffline $out
  substituteInPlace $out \
    --replace-fail '/usr/bin/chronyc' '${chrony}/bin/chronyc'
  chmod +x $out
  patchShebangs $out
''
