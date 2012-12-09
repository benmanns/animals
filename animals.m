% List of animal directories and labels.
animalDirectories = {'alligator', 'ant', 'bear', 'beaver', 'dolphin', 'frog', 'giraffe', 'leopard', 'monkey', 'penguin'};

% Resized Image Dimensions
height = 64;
width = 64;

% Image dataset
% (label) + (height) * (width) * (color channels)
X = zeros(0, 1 + height * width * 3);

% Label that we can use to check accuracy or inspect outputs.
label = 1;
for animal = animalDirectories
  fprintf('Loading %s images.\n', char(animal));
  if exist('OCTAVE_VERSION')
    fflush(stdout);
  end
  files = glob(char(strcat(animal, '/*')))';

  for file = files
    im = imread(char(file));
    im = imresize(im, [height, width]);
    im = double(im) / 255;
    if (size(size(im), 2) != 3)
      im = repmat(im, [1, 1, 3]);
    end
    X(size(X, 1) + 1, :) = [label; reshape(im, [height * width * 3, 1])];
  end

  label++;
end

% Shuffle X
X = X(randperm(rows(X)), :);

% Shift off label vector
Y = X(:, 1);
X = X(:, 2:end);

% Run k-means
K = size(animalDirectories, 2);
max_iters = 100;
initial_centroids = kMeansInitCentroids(X, K);
[centroids, idx] = runkMeans(X, initial_centroids, max_iters);

for i = 1:K
  fprintf('Cluster %d\n', i);
  if exist('OCTAVE_VERSION')
    fflush(stdout);
  end

  % Select all Xs matching index i
  xs = X(idx == i, :);

  for j = 1:size(xs, 1)
    x = xs(j, :);
    img = reshape(x, [width, height, 3]);
    imshow(img);
    pause;
  end
end
