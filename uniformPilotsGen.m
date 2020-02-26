function [pilots] = uniformPilotsGen(num_pilots)
%UNIFORMPILOTSGEN Summary of this function goes here
%   uniformPilotsGen generates the pilots that are uniformly distributed on
%   a complex unit circle.

pilots = cell(1, length(num_pilots));
for ii = 1:length(num_pilots)
    pilot_angles = linspace(0, pi/2, num_pilots(ii));
    pilots{1, ii} = exp(1j*pilot_angles.');
end

end

