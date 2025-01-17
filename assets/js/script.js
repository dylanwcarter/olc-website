const gallery = document.getElementById('gallery');
const prevPageButton = document.getElementById('prevPage');
const nextPageButton = document.getElementById('nextPage');
const pageSelect = document.getElementById('pageSelect');

let currentPage = 1;
const imagesPerPage = 20; // Number of images per page
let totalImages = 0;
let totalPages = 0;

// Get the folder name from the gallery's data-folder attribute
const folder = gallery.getAttribute('data-folder');

// Fetch image data dynamically based on the folder
async function fetchImageData() {
    try {
        // Fetch the list of images from the folder
        const response = await fetch(`assets/images/${folder}/image-list.json`);
        if (!response.ok) {
            throw new Error('Failed to fetch image list');
        }
        const data = await response.json();
        return data.images; // Array of image URLs
    } catch (error) {
        console.error('Error fetching image data:', error);
        return [];
    }
}

function loadImages(page, imageData) {
    gallery.innerHTML = ''; // Clear existing images
    const startIndex = (page - 1) * imagesPerPage;
    const endIndex = startIndex + imagesPerPage;

    imageData.slice(startIndex, endIndex).forEach(image => {
        const img = document.createElement('img');
        img.src = `assets/images/${folder}/${image}`; // Use the folder name
        img.alt = "Gallery Image";
        gallery.appendChild(img);
    });

    // Update pagination controls
    prevPageButton.disabled = page === 1;
    nextPageButton.disabled = page === totalPages;
    pageSelect.value = page;
}

async function init() {
    const imageData = await fetchImageData();
    totalImages = imageData.length;
    totalPages = Math.ceil(totalImages / imagesPerPage);

    // Populate the dropdown with page numbers
    for (let i = 1; i <= totalPages; i++) {
        const option = document.createElement('option');
        option.value = i;
        option.textContent = `Page ${i}`;
        pageSelect.appendChild(option);
    }

    // Load the first page
    loadImages(currentPage, imageData);

    // Add event listeners for pagination buttons
    prevPageButton.addEventListener('click', () => {
        if (currentPage > 1) {
            currentPage--;
            loadImages(currentPage, imageData);
        }
    });

    nextPageButton.addEventListener('click', () => {
        if (currentPage < totalPages) {
            currentPage++;
            loadImages(currentPage, imageData);
        }
    });

    // Add event listener for the dropdown
    pageSelect.addEventListener('change', (e) => {
        currentPage = parseInt(e.target.value);
        loadImages(currentPage, imageData);
    });
}

init();