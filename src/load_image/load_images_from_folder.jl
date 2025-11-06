
# Fonction pour charger les images et leur attribuer une étiquette

function load_images_from_folder(folder_path)
    classes = readdir(folder_path)
    images = []
    labels = []

    for (i, class) in pairs(classes)
        class_path = joinpath(folder_path, class)
        for img_file in readdir(class_path)
            img_path = joinpath(class_path, img_file)
            img = FileIO.load(img_path)
            push!(images, img)
            push!(labels, class)  
        end
    end

    return images, labels
end
