# Project Notes

## Usage / Notes 
- I've already preloaded the test environment with data, but to do that you'd need to log in to the admin interface at https://protected-badlands-15455.herokuapp.com/admin. Go to the individual entity page and hit "Upload CSV" in the top right corner. The requrest will time out and show an error page for product / inventory, but the actual data will still be imported. I didn't move this into a background to avoid the request timeout in the interest of time.
- The credentials for the admin interface are "admin@productinventory.com / changeme". Naturally I would not normally allow the seed user to stick around in production :)
- The JWT_SECRET _is_ specified by environment variables, so it's not the one in the test file. I thought demonstrating that I understood that security practice was important enough to bother with.
- I've included a postman collection in the report for testing these calls. To use it you need to run the "login" request, then store the resulting token into the collection level Auth settings (only way I could see to do this in Postman is clicking "This request is using an authorization helper from collection ProductInventory." I'm sure they have a nice way to automate this but I didn't want to spend time on that either.)
- I did rename a couple of columns, e.g. "shipping_price" seems like it should be "shipping_price_cents" to be consistent with the other price columns. I tried to make the API GET endpoints return the alias from the CSV but the inputs require my name.


## Assumptions / Simplications

- We don't have a list of what information is important for the list / detail endpoint so I included all in both. I think you could guess that anything relating to presenting a list of items (URL, name, desc, etc) would be important and something that might be more about showing admin details or a product page (shipping price, etc) would be in the detail view.
- I renamed some of the columns in the CSV into names that made more sense to me in the models, e.g. "product_name" => "name", "shiping_price" => "shipping_price_cent" (to be consisent with the inventoroy record). To be consistent with the CSV I did try to return then in the format in the CSV
- Here's a ERD I put together for the models: https://lucid.app/lucidchart/invitations/accept/inv_f304912b-2399-40e8-9f34-314e28b05a45?viewport_loc=-11%2C-1383%2C2439%2C1080%2C0_0
- The fact that the style / type / brand keys in the search don't specify wildcards makes me think I'm right that they dropdowns rather than free entry so if a brand / type / etc is entered that doesn't exist I'm reading that as a failure
- the search endpoint is case sensitive

- I think size / color on inventory should be separate classes like we did for brand, style, etc but in the interest of time I've left them the same.
- In the lucid chart linked I went into a path I initially planned and subsequently abandoned. I'd be glad to talk more about that if you'd like (or can give a cleaned up "final" version if you'd prefer)
- My initial plan was to consume the product / inventory CSVs using the API itself, so write a script that read the CSV and wrote the records in using the API. I didn't do that because the CSVs had IDs in them, I was worried there'd be tests on your end that would require the IDs to match. I don't think an API should allow consumers to specify the ID of its new records so I didn't want to build that into the API. 


## Follow-ups / TODOs
- I didn't feel confident on what the unique constraints should be on inventory / product so I didn't add backing DB constraints. I initially though product name / sku would have to be unique per-account but that was incorrect in the full dataset. Once I understood the constraints here I'd fix that.
- I'd also like to cleanup the size / color / type / branch / style fields -- I think they should all be separate entities but probably some should be system level and some should be account level. 
- I wanted to publish a Swagger server too but didn't get to it. I'd rather spend more time on Part 2 so dropping that for now.