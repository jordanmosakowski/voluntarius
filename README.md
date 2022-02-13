# Voluntarius

## Inspiration
There are millions of ways to help people, and there are millions of people in need of help. 
The hardest part is matching the helpful volunteers with those in need on an individual basis. Voluntarius rose out of this need, a bridge between aspiring volunteers and anyone nearby in need of help. The app was conceived to allow those in need to post their tasks, and have all nearby volunteers be able to get in touch with and help them.

## Features and Highlights
The main feature revolves around “Job Postings.” Any user can create a job posting, specifying when the job will take place, its description, and how many volunteers are requested. This request enters the database and is then displayed on the home page of any volunteer that logs in within a short radius. A volunteer will be able to see all the listings by how close the jobs are to the volunteer, and will be able to select a job on an interactive map, assess it, and apply for it. The poster of the job then approves the applicant, and a chat room is created for the job. Any user that is hosting or accepted for a job is able to access the chat, and the chat will update live with any messages. 

After a volunteer has completed a job, the host will verify their hours, and the hours from each event that the helper has participated in can be neatly exported in a pdf. This angle of the app serves as motivation for volunteering, offering a simple and quick way for anyone to record and report volunteer hours. Along with the verification, a host will give each helper a rating out of five stars, which is recorded in the user’s profile with their average rating. Along with this, we incorporated a push notification system for all platforms that notifies the user whenever a volunteer signs up for a job or when they receive a chat message.

## How We Built It
We decided to use [Flutter](https://flutter.dev/) to design the frontend. Flutter allows for easy development for iOS, Android, and the web, which is essential for being able to communicate with volunteers on the go. It also includes libraries that easily connect to Google Maps, helping users find nearby jobs. For the backend, we utilized [Firebase](https://firebase.google.com/) and [node.js](https://nodejs.org/en/). Firebase is one of the best database tools to help manage users and requests and is the basis for our authentication. Node.js helps process changes in the database and helps the system be as reactive as possible. 

## What We Learned
Throughout the process, all team members learned various things about application development. Certain members of the team were completely unfamiliar with web and mobile development prior to this hackathon, and gained valuable experience creating their own pages. Flutter allowed us to learn an incredible amount about the technical aspects of building a website, and Firebase worked in the same way for the backend as team members learned how to make the frontend of a website communicate with a cloud-hosted database. 

Equally important was the communication and collaboration skills that we learned along the way. Each member had skills in various areas of computer science, and it was quintessential that we worked together to combine our talents. We familiarized ourselves with working on a team project, and prioritizing tasks to complete a deadline.

## What's Next?
We think that Voluntarius has the potential to foster a community built on looking out for those around us. Providing the best possible user experience and extra incentives for volunteers could help us attract more users and in turn strengthen a neighborhood of caring. Some additional features that we could implement include a local leaderboard to reward the most active volunteers and Single Sign On (SSO) with Google, Apple, etc.

## Built With
`dart` `flutter` `firebase` `javascript` `nodejs`

## Check It Out!
[Live Site](https://voluntarius-h4h.web.app)