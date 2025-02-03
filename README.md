# iOS recruitment task for APMC
This is a recruitment task for A Parent Media Company. This app retrieves a list of available episodes from a server that can be streamed.

## Tools

Built using **Xcode 16.2** and **SwiftUI 5**. 


## Assumptions and Limitations

- The app assumes that the user has a reliable connection to the internet to populate the episode list and stream the videos.
- The app assumes the user has an up-to-date iOS device.

## Design

When presented with this task, I designed these screens.
![IMG_3259](https://github.com/user-attachments/assets/4cfb2ac3-68db-47e2-bbd4-e6b015cf3b00)

For presentation, I designed a simple logo for the app and named it "Play It Safe"
![play it safe](https://github.com/user-attachments/assets/99280871-a5e1-49c4-a804-fe97781576a6)

## API Reference

The API provided retrieves a list of the available videos.

#### Get all items

```http
  GET https://run.mocky.io/v3/8419df8e-0160-4a35-a1e6-0237a527c566
```
![PNG image](https://github.com/user-attachments/assets/a08c16f4-8f56-438f-ba77-1e891448a938)


## Architecture

For this app, I went with a **MVVM** architecture.

Some of the reasons for my rationale:
- SwiftUI heavily relies on MVVM architecture. Using @Published properties makes it easier to manage the change of states of the View Model in the View.
- Separation of concerns: by using MVVM, the data's logic and handling are not getting mixed up and are easier to maintain. Although this app is small, I like to think of projects as kids that will eventually grow up, so why not invest some time now and make them maintable for their eventual growth and change?
- For unit testing: I included some simple unit tests where the business logic can be independently tested without involving any other component.


## FAQ

#### Did I face any issues?

Not really. Although I prefer UIKit over SwiftUI, I found this task really easy to manage with this technology. Also, the documentation for SwiftUI is getting better.

#### How long did it take?

This task took me around 3 and a half hours to complete.


## Further development

To build up this task, I would like to:

- Add a thumbnail to the episodes in the episode list.
- Create custom player buttons for the PlayerView.
- Build and design the brand to have a more cohesive design across the app.
## Authors

Once again, thank you so much for taking the time to review my code.

- Lydia González (lydiamariong@gmail.com)
