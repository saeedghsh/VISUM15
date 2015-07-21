function indices_codewords = f_assign_codewords(vec_glcm_val,GLCMcent)

% Assignment to the closest codeword

for(i=1:size(vec_glcm_val,1))
    for(j=1:size(GLCMcent,1))
        % Euclidean distance between 2 vectors
        dist = vec_glcm_val(i,:) - GLCMcent(j,:);
        dist = dist .* dist;
        distances(j) = sqrt(sum(dist)); 
    end
    [min_value,min_id] = min(distances);
    indices_codewords(i) = min_id;
    clear distances,
end


end
     