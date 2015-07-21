function [] = f_display_results(Imatges,num_imatges,num_results,distancias) 

figure, 

super_max = max(max(distancias));

posicion = 1;
for(i=1:num_imatges)
    for(j=1:num_results)
        distancias(i,:);
        [minimum_v,minimum_id] = min(distancias(i,:));        
        subplot(num_imatges, num_results, posicion);
        imshow(Imatges{minimum_id}.im);
        distancias(i,minimum_id)= super_max;
        posicion = posicion+1;
    end
end


