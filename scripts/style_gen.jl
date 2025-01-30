open("./.site/style.css", "w") do style
    files = readdir("./style");
    for file in files
        open("./style/$file", "r") do stream
            content = read(stream, String);
            write(style, "$content\n");
        end
    end
end
