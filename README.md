# Language project is an app that allow a simple way for learning language. App uses Google WebAPI for words cloud access. App also allows login with Facebook

This app uses Google Cloud Endpoints Frameworks and Facebook integration. 

## Screen flow

1. User login page using either setting up a custom account or login using facebook

2. User can register by entering a very limited records : first name, last name, login id, password and display name

3. Once logged in, system displays a word dashboard. Word dashboard, pulls master word list from Google Cloud Endpoint. It then shows how many total words are there. It then compares total words with the words that the user already knows and show %. 

4. From this Dashboard screen, user can also add new word. In case user decides to add new word, this new word screen calls Google Clould Endpoints. This new word is stored in Google Datastore

5. From this Dashboard screen, user can also start learning. User can click on learn button as well and test out the knowledge. 

6. From learn screen, in case user is able to find the translated word at first time, it becomes into the mastered word, if not, then it will be part of the Shaky list

7. System also uses Core data to store downloaded words into local repository.


## API and other dependencies

1. Google Cloud Endpoints to store words and pull words 
2. Facebook integration
