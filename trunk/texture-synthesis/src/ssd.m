%function result = ssd(origin, overlap)
%�p��origin�Poverlap�C��pixel��sum of squared distances
%
%Inputs:
%   origin - larger image
%   overlap - smaller image
%
%Outputs:
%   result�̭��C��pixel�]�torigin�Poverlap��ssd

function result = ssd(origin, overlap)

convolution = ones(size(overlap,1), size(overlap,2));

%�C���C����}�ӭp��ssd
for k=1:size(origin,3),
    origin_color = origin(:,:,k);
    overlap_color = overlap(:,:,k);
    
    origin_filtered = filter2(convolution, origin_color.^2, 'valid');
    overlap_filtered = sum(sum(overlap_color.^2));
    origin_overlap = filter2(overlap_color, origin_color, 'valid').*2;

    if( k == 1 )
        result = ((origin_filtered - origin_overlap) + overlap_filtered);
    else
        result = result + ((origin_filtered - origin_overlap) + overlap_filtered);
    end;
end;

