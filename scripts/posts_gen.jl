using Dates

filename = ARGS[1];
template = open("./templates/page_template.html") do stream
    read(stream, String)
end

title, author, date = open("./posts/$filename.org") do stream
    text = read(stream, String);

    title = match(r"#\+TITLE: (.*)\n", text);
    title = title.captures[1];

    author = match(r"#\+AUTHOR: (.*)\n", text);
    author = author.captures[1];

    date = match(r"#\+DATE: (.*)\n", text);
    date = date.captures[1];
    date = Date(date, dateformat"y-m-d");
    date = Dates.format(date, "dd/mm/yyyy");

    title, author, date
end

open("./.site/index.csv", "a") do stream
    write(stream, "$filename.html\t\"$title\"\t$date\t\"$author\"\n");
end

post = open("./templates/post_template.html") do stream
    read(stream, String)
end

content = open("./.site/temp_posts/$filename.html") do stream
    read(stream, String)
end

content = replace(content, "\n" => "\n" * (" " ^ 12));
post = replace(post, "%POST_TITLE%" => title);
post = replace(post, "%POST_AUTHOR%" => author);
post = replace(post, "%POST_DATE%" => date);
post = replace(post, "%POST_CONTENT%" => content);

template = replace(template, "%PAGE_TITLE%" => "$title - Meu Mundo de Lógica");
template = replace(template, "%CSS_FILE%" => "../style.css");
template = replace(template, "%INDEX_LINK%" => "../");
template = replace(template, "%POSTS%" => post);

open("./.site/posts/$filename.html", "w") do stream
    write(stream, template);
end
