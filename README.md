# ARMonstersApp
 The user can catch monsters in augmented reality on a physical map next to him.

When the application is launched, it is checked for access to the user's geolocation. When accessing the user's geolocation on the new screen, the user can see the monsters around him on the map, go to the capture of the selected monster or see his team.

When loading the screen, a list of 30 random monsters is generated in random locations within a kilometer radius of the user's geolocation. Then, every 5 minutes, the list is updated: with a 20% probability, each monster is removed from the list (and from the map) and 6 random monsters are added to the list in random locations within a kilometer radius of the user's geolocation. 
If the distance from the user to the monster is 100 meters or less, a transition occurs to the screen with the selected monster. In this case, the selected monster is removed from the list of monsters on the map;
if the distance is more than 100 meters, then a system alert is displayed: "You are too far from the monster – {n} meters." When switching to the screen, a level from 5 to 20 is randomly generated for the monster. By pressing the button with a probability of 20%, the player catches a monster: with a successful capture, the monster is added to the team and cached, the system popup is shown: " You have caught the monster {n} in your team" (where {n} is the name of the monster), with the "Return to the map" button.
![243703643-65bb2700-701e-4986-932c-c353d98894a9](https://github.com/nataliiagrigoreva/ARMonstersApp/assets/123460015/3711b73a-a744-49fb-823e-166ce9f6eb2c)


![Simulator Screen Shot - iPhone 11 - 2023-06-06 at 16 00 12](https://github.com/nataliiagrigoreva/ARMonstersApp/assets/123460015/65bb2700-701e-4986-932c-c353d98894a9)
![Simulator Screen Shot - iPhone 11 - 2023-06-06 at 16 00 20](https://github.com/nataliiagrigoreva/ARMonstersApp/assets/123460015/aba402eb-f5b5-41d9-9897-4138b0b34157)
![Simulator Screen Shot - iPhone 11 - 2023-06-06 at 16 01 26](https://github.com/nataliiagrigoreva/ARMonstersApp/assets/123460015/b6d02521-8885-419b-9a35-81c6200fe8da)
![Simulator Screen Shot - iPhone 11 - 2023-06-06 at 16 01 31](https://github.com/nataliiagrigoreva/ARMonstersApp/assets/123460015/0e02f1b3-e356-4884-91a3-43156c720f20)
![Simulator Screen Shot - iPhone 11 - 2023-06-06 at 16 01 36](https://github.com/nataliiagrigoreva/ARMonstersApp/assets/123460015/f45da3de-22ed-49ff-a6b6-77602ae1d059)
![Simulator Screen Shot - iPhone 11 - 2023-06-06 at 16 01 39](https://github.com/nataliiagrigoreva/ARMonstersApp/assets/123460015/949ebfbd-450e-44d8-a284-5183fd195bbd)![Simulator Screen Shot - iPhone 11 - 2023-06-06 at 16 01 44](https://github.com/nataliiagrigoreva/ARMonstersApp/assets/123460015/cb465791-8ba4-489b-ae11-831ab6bb5021)
![Simulator Screen Shot - iPhone 11 - 2023-06-06 at 16 01 53](https://github.com/nataliiagrigoreva/ARMonstersApp/assets/123460015/4c42d483-c000-4eb9-8b64-fbe3b4d6d62a)
![Simulator Screen Shot - iPhone 11 - 2023-06-06 at 16 02 06](https://github.com/nataliiagrigoreva/ARMonstersApp/assets/123460015/efa3f5f0-97af-4803-9f86-0646c4c1fa32)

