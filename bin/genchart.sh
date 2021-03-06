
  echo 
  echo "--- Diagram template"
  #echo "<link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.2/css/all.min.css' integrity='sha512-HK5fgLBL+xu6dm/Ii3z4xhlSUyZgTT9tuc/hSrtw6uzJOvgRr2a9jyxxT1ely+B+xFAmJKVSTbpM/CuL7qxO8w==' crossorigin='anonymous' /> " >> $filename
  echo "\`\`\`mermaid"  >> $filename
  echo "%%{init: {'theme': 'dark', 'themeVariables': { 'primaryColor': '#ff0000'}}}%%" >> $filename
  echo "" >> $filename
  echo "graph LR" >> $filename
  echo "A[$title] ---|$knot_note| B(fa:fa-signature)" >> $filename
  echo "B-->C[fa:fa-heart]" >> $filename
  echo "B-->D[fa:fa-heart-broken]" >> $filename
  echo "" >> $filename
  echo "\`\`\`" >> $filename
  echo "" >> $filename
