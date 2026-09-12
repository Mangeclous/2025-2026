<html>
<head>
<meta charset="UTF-8">
<title>◊select['h2 doc] </title>
<link rel="stylesheet" type="text/css" media="all" href="styles.css" />
</head>
<body>◊(->html doc #:splice? #t)
◊(define prev-page (previous here))
◊when/splice[prev-page]{
<div id="prev">← <a href="◊|prev-page|">◊(select 'h2 prev-page)</a></div>}
◊(define next-page (next here))
◊when/splice[next-page]{
<div id="next"><a href="◊|next-page|">◊(select 'h2 next-page)</a> →</div>}
</body>
</html>