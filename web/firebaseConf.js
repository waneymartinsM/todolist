function doSomething(){
    // Your web app's Firebase configuration
    // For Firebase JS SDK v7.20.0 and later, measurementId is optional
    var firebaseConfig = {
      apiKey: "AIzaSyCxp-gu4DZtRHrFM6jFaFHtvVf6lbgfPWA",
        authDomain: "to-do-list-36ba1.firebaseapp.com",
        projectId: "to-do-list-36ba1",
        storageBucket: "to-do-list-36ba1.appspot.com",
        messagingSenderId: "582799119485",
        appId: "1:582799119485:web:95fbcad0f089e0c11b4d14",
        measurementId: "G-MS2JGHSGDF"
      };
  // Initialize Firebase
  firebase.initializeApp(firebaseConfig);
  firebase.analytics();
}
doSomething();