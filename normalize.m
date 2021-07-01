function max_n = normalize(Data,MVC)

if ~isempty(MVC)
    max_n=MVC;
else
    max_n=max(max(Data));
end

end

