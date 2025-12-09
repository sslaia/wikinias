# WikiNias

**WikiNias** is a Flutter application dedicated to the preservation and learning of the Nias language and culture. This repository contains the source code for the app and the static landing page hosted via GitHub Pages.

<div align="center">
  <img src="./wikinias-icon.png" alt="WikiNias Logo" width="150"/>
  <br><br>
  <a href="https://play.google.com/store/apps/details?id=com.blogspot.wikinias">
    <img src="https://img.shields.io/badge/Google_Play-Download-green?style=for-the-badge&logo=google-play" alt="Download on Google Play">
  </a>
  <a href="https://wikinias.blogspot.com">
    <img src="https://img.shields.io/badge/Website-Visit_Blog-orange?style=for-the-badge" alt="Official Website">
  </a>
</div>

## 🚀 Key Features

[cite_start]As highlighted in the app[cite: 1]:
* **New Modules:** Faster loading and enhanced imagery.
* **New Search:** Instant search functionality.
* **New Menu Drawer:** Quick switching between app modules.
* **Customization:** Font settings and Dark Mode support.
* **Content Creation:** Forms to create new pages or entries.
* **Cultural Learning:** Courses on proverbs, songs, and tales.
* **Visuals:** Galleries and Nias ornament explorations.

## 🛠 How to Edit the Landing Page

The landing page (`index.html`) is a self-contained file including HTML, CSS, and JavaScript.

### Changing Text & Translations
The website supports **English** and **Indonesian**. To change the text, locate the `<script>` tag at the bottom of `index.html`.

Look for the `translations` object:

```javascript
const translations = {
    en: {
        heroTitle: "Gateway to Nias Culture",
        // ... change English text here
    },
    id: {
        heroTitle: "Gerbang Budaya Nias",
        // ... change Indonesian text here
    }
};
