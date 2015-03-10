function W = hebbianLearning(p)
% HEBBIANLEARNING Regle d'apprentissage de Hebb
%  W = hebbianLearning(p) renvoie une matrice de connexion W basee sur la
%  regle d'apprentissage de Hebb pour un jeu de pattern d'apprentissage P
%  pour un reseau de Hopfield. P est un tableau NxM, ou N est le nombre de
%  neurones du reseau et M le nombre de patterns a memoriser. La matrice W
%  est de taille NxN.
%
%  La regle de Hebb est inspiree du concept "Neurons that fire together,
%  wire together". Les connexions W(i,j) sont renforcees si les patterns
%  aux position i et j sont semblables.

[n,m]=size(p);

W = zeros(n);
for i = 1:n
    for j = 1:n
        W(i,j)=mean(p(i,:).*p(j,:));
    end
    W(i,i) = 0;
end