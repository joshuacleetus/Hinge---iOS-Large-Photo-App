# Hinge---iOS-Large-Photo-App
iOS Large Photo App homework assignment

Write an app that downloads 10 very large images concurrently, and then get them on the screen. Create a structure so that when all the results come back asynchronously, they are displayed in the right order.  Everything should be threadsafe.

Clicking an image should show a “gallery” activity with a large view of the image. Every 2 seconds the image should progress to the next one in the list, showing the position of that image in the toolbar (e.g. 5/16) Inside the gallery a button (in toolbar) should be present to remove the image from the gallery and list. After removal the previous list should be shown to the user (with needed image removed from the list)
 
Please submit link to source code. Your homework will be reviewed by engineers here at Hinge. We'll be looking for the same things we'd look for in real life contributions, including great tests and documentation.

Example large images:

http://upload.wikimedia.org/wikipedia/commons/8/81/Carn_Eige_Scotland_-_Full_Panorama_from_Summit.jpeg
http://upload.wikimedia.org/wikipedia/commons/1/1c/NGC_6302_Hubble_2009.full.jpg
http://upload.wikimedia.org/wikipedia/commons/3/3c/Merging_galaxies_NGC_4676_(captured_by_the_Hubble_Space_Telescope).jpg
http://spaceflight.nasa.gov/gallery/images/shuttle/sts-125/hires/s125e012033.jpg
http://mayang.com/textures/Plants/images/Flowers/large_flower_6080110.JPG
http://setiathome.berkeley.edu/img/head_20.png
http://upload.wikimedia.org/wikipedia/commons/c/ca/Star-forming_region_S106_(captured_by_the_Hubble_Space_Telescope).jpg
http://hdwallpaper.freehdw.com/0003/nature-landscapes_widewallpaper_large-flowers-close-up_21096.jpg
http://media.cleveland.com/neobirding_impact/photo/11460704-large.jpg
http://www.factzoo.com/sites/all/img/birds/great-hornbill-flying.jpg
