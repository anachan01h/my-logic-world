using DelimitedFiles

template = open("./templates/page_template.html") do stream
    read(stream, String)
end

posts = readdlm("./.site/index.csv");
posts = sortslices(posts, dims=1, rev=true);

content = ""
post_template = open("./templates/post_template.html") do stream
    read(stream, String)
end

for i=1:size(posts, 1)
    title = posts[i,2];
    file = posts[i,1];
    post = replace(post_template, "%POST_TITLE%" => "<a href=\"./posts/$file\">$title</a>");
    post = replace(post, "%POST_AUTHOR%" => posts[i,4]);
    post = replace(post, "%POST_DATE%" => posts[i,3]);
    post = replace(post, "%POST_CONTENT%" => "");
    global content = content * post;
end

template = replace(template, "%PAGE_TITLE%" => "Meu Mundo de Lógica");
template = replace(template, "%CSS_FILE%" => "./style.css");
template = replace(template, "%INDEX_LINK%" => "./index.html");
template = replace(template, "%POSTS%" => content);

open("./.site/index.html", "w") do stream
    write(stream, template);
end
