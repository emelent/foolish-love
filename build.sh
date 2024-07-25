title="test-project" 
webtitle="Test Project"
width=400
height=300


# make customized web export using my own lovejs download
cd../lovejs
npx love.js-c-t "${webtitle}"../${title}/builds/love/${title}.love../${title}/builds/lovejs sed "s/QTITLE@/${webtitle}/g; s/QWIDTH@/${width}/g; s/QHEIGHT@/${height}/g" html-template.html >
index.html
mv index.html…/${title}/builds/lovejs/index.html
cd../${title}/builds/lovejs/theme
rm *
cal
rmdir theme
