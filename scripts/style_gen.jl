open("./.site/style.css", "w") do style
    files = readdir("./style");
    for file in files
        open("./style/$file", "r") do stream
            write(style, read(stream, String));
        end
    end
end
