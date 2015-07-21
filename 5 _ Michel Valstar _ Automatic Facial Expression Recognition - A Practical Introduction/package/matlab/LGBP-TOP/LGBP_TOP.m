function features = LGBP_TOP(matrix, blocks)	
	nscales = 3;
	norients = 6;
	
	gmps = [];
	for n = 1:size(matrix, 3)
		img = matrix(:, :, n);
		lgmps = gaborconvolve(img, nscales, norients, 3, 2.1, 0.55, 1.2, 0);
		lgmps = reshape(lgmps', 1, nscales * norients);
		gmps = cat(1, gmps, lgmps);
	end
	
	features = [];
	for n = 1:size(gmps, 2)
		block = gmps(:, n);

		blbps = [];
		for k = 1:size(block, 1)
			img = (abs(block{k, 1})).^2;
			ilbps = lbp(img, 1, 8, 0, 'l');
			blbps = cat(3, blbps, ilbps);
		end
		blbps = uint32(blbps);
		
		blbpsXY = blbps(:, :, 1);
		for k = 2:size(blbps, 3)
			blbpsXY = blbpsXY + blbps(:, :, k);
		end
		blbpsXY = blbpsXY / size(blbps, 3);

		blbpsXT = blbps(:, 1, :);		
		for k = 2:size(blbps, 2)
			blbpsXT = blbpsXT + blbps(:, k, :);
		end
		blbpsXT = blbpsXT / size(blbps, 2);	
		
		blbpsYT = blbps(1, :, :);		
		for k = 2:size(blbps, 1)
			blbpsYT = blbpsYT + blbps(k, :, :);
		end
		blbpsYT = blbpsYT / size(blbps, 1);
		
		mapping = getmapping(8, 'u2');
		featuresXY = blockFeatures(blbpsXY, blocks(1), blocks(2), 'histogram', mapping);
		featuresXT = blockFeatures(blbpsXT, blocks(1), blocks(2), 'histogram', mapping);
		featuresYT = blockFeatures(blbpsYT, blocks(1), blocks(2), 'histogram', mapping);
		
		features = cat(2, features, featuresXY);
		features = cat(2, features, featuresXT);
		features = cat(2, features, featuresYT);
	end
end
