function [ participant_id_socio_features ] = get_socio_bio_features( file, file_format, participant_column, columns_to_be_extracted, rows_to_be_extracted)

fid = fopen(file);
A = textscan(fid, file_format, 'Delimiter', ',');
fclose(fid);
nRows = size(rows_to_be_extracted,2);
nColumns = size(columns_to_be_extracted,2);
participant_id_socio_features = zeros(nRows,nColumns+1);%+1 for participant_id

participant_id_socio_features(:,1) = A{participant_column};

for i=1:1:nColumns
    participant_id_socio_features(:,i+1) = A{columns_to_be_extracted(i)};
end    

end