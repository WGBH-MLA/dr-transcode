# grab output of 'how many pods'
OUTPUT=$(kubectl --kubeconfig=/mnt/kubectl-secret --namespace=dr-transcode get pods)
# check whether the command ended
if [ $(echo "$OUTPUT" | grep 'Unable to connect to the server: net/http: TLS handshake timeout' | wc -l) -eq 0 ] && [ $(echo "$OUTPUT" | grep 'runtime error: invalid memory address or nil pointer dereference' | wc -l) -eq 0 ]; then
  # old tls handshake error, and new 'gorouutine' nil error
  # give the actual number, because we succeeded in getting a result
  echo $(echo "$OUTPUT" | grep '^dr-ffmpeg' | wc -l)
else
  # we *did* get the TLS handshake error above, give a nonsense answer
  echo "-1"
fi
