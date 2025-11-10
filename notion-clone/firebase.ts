// Import the functions you need from the SDKs you need
import { getApp, getApps, initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { getFirestore } from "firebase/firestore";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
    apiKey: "AIzaSyBh_WMkqaOQTuFQZdkrhCjsBTUyyvSAy9I",
    authDomain: "notion-clone-b8f46.firebaseapp.com",
    projectId: "notion-clone-b8f46",
    storageBucket: "notion-clone-b8f46.firebasestorage.app",
    messagingSenderId: "18227930249",
    appId: "1:18227930249:web:1fea96ee0211d8a4609258",
    measurementId: "G-X3QNPRW9RG"
};

// Initialize Firebase
const app = getApps().length === 0 ? initializeApp(firebaseConfig) : getApp();
const db = getFirestore(app);

export { db };