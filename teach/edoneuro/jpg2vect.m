function p = jpg2vect(filename)
% JPG2VECT transforme une image JPG RGB en vecteur normalise pour le reseau
% de Hopfield. FILENAME est le nom d'un fichier JPG et P est un vecteur
% colonne de taille (NxM), si l'image est de taille NxM.

p = importdata(filename);

p = p(:,:,1);

[n,m] = size(p);

p = double(p);
p = reshape(p,n*m,1);
p = p/max(p);
p = p - mean(p);