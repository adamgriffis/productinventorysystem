# Project Notes

Just keeping a running list of assumptions / simplications I'm making here

- We don't have a list of what information is important for the list / detail endpoint so I included all in both. I think you could guess that anything relating to presenting a list of items (URL, name, desc, etc) would be important and something that might be more about showing admin details or a product page (shipping price, etc) would be in the detail view.
- I renamed some of the columns in the CSV into names that made more sense to me in the models, e.g. "product_name" => "name", "shiping_price" => "shipping_price_cent" (to be consisent with the inventoroy record). To be consistent with the CSV I did try to return then in the format in the CSV
- Here's a ERD I put together for the models: https://lucid.app/lucidchart/invitations/accept/inv_f304912b-2399-40e8-9f34-314e28b05a45?viewport_loc=-11%2C-1383%2C2439%2C1080%2C0_0
- The fact that the style / type / brand keys in the search don't specify wildcards makes me think I'm right that they dropdowns rather than free entry so if a brand / type / etc is entered that doesn't exist I'm reading that as a failure
- the search endpoint is case sensitive

- I think size / color on inventory should be separate classes like we did for brand, style, etc but in the interest of time I've left them the same.
- In the lucid chart linked I went into a path I initially planned and subsequently abandoned. I'd be glad to talk more about that if you'd like (or can give a cleaned up "final" version if you'd prefer)