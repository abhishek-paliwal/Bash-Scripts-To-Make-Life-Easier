NewCodeContent ="\n <!-- HTML RECIPE CODE BLOCK BELOW THIS --> \n" +
"\n <div id='recipe-here'></div>" +
"\n <!-- /------------/ -->" +
"\n <div id='recipe-print-block' style='line-height: 1.1; border: 1px dashed black; padding: 10px; font-size: 14px; font-family: sans-serif; '>" +
"\n     <div>" +
"\n <!-- /------------/ -->" +
"\n         <h3><span itemprop='name'>" + recipeName + "</span> [RECIPE]</h3>" +
"\n         <span itemprop='description'>" + recipeDescription + "</span>" +
"\n <!-- /------------/ -->" +
"\n         <div class='flexbox_recipe_container'>" +
"\n <!-- /------------/ -->" +
"\n             <div class='flexbox_recipe_left'><!-- recipe left flexbox starts -->" +
"\n <!-- /------------/ -->" +
"\n                         <img itemprop='image' src='" + imageUrl + "' width='150px'>" +
"\n <!-- /------------/ -->" +
"\n                         <div itemprop='aggregateRating'>" +
"\n                             <span style='color: #cd1d63;'>&hearts; &hearts; &hearts; &hearts; &hearts;</span>" +
"\n                             (Rating: <span itemprop='ratingValue'>" + ratingValue + "</span> from <span itemprop='ratingCount'>" + ratingCount + "</span> reviews)" +
"\n                         </div>" +
"\n <!-- /------------/ -->" +
"\n                         <h4>INGREDIENTS</h4>" + recipeIngredients + "<hr>" +
"\n <!-- /------------/ -->" +
"\n             </div><!-- recipe left flexbox ends -->" +
"\n <!-- /------------/ -->" +
"\n             <div class='flexbox_recipe_right'><!-- recipe right flexbox starts -->" +
"\n                         <table border='0' cellpadding='1' cellspacing='5' width='100%'>" +
"\n                             <tr>" +
"\n                                 <th style='text-align:center; width:33%; color:#cd1d63;'>&#128336; Prep time</th>" +
"\n                                 <th style='text-align:center; width:33%; color:#cd1d63;'>&#128336; Cook time</th>" +
"\n                                 <th style='text-align:center; width:33%; color:#cd1d63;'>&#128336; Total time</th>" +
"\n                             </tr>" +
"\n <!-- /------------/ -->" +
"\n                             <tr>" +
"\n                                 <td style='text-align:center'><time datetime='" + prepTime + "' itemprop='prepTime'>" + prepTimeHuman + "</time></td>" +
"\n                                 <td style='text-align:center'><time datetime='" + cookTime + "' itemprop='cookTime'>" + cookTimeHuman + "</time></td>" +
"\n                                 <td style='text-align:center'><time datetime='" + totalTime + "' itemprop='totalTime'>" + totalTimeHuman + "</time></td>" +
"\n                             </tr>" +
"\n <!-- /------------/ -->" +
"\n                             <tr>" +
"\n                                 <th style='text-align:center; width:33%; color:#cd1d63;'>&#9782; Category</th>" +
"\n                                 <th style='text-align:center; width:33%; color:#cd1d63;'>&#9832; Cuisine</th>" +
"\n                                 <th style='text-align:center; width:33%; color:#cd1d63;'>&#9786; Serves</th>" +
"\n                             </tr>" +
"\n <!-- /------------/ -->" +
"\n                             <tr>" +
"\n                                 <td itemprop='recipeCategory' style='text-align:center; width:33%;'>" + recipeCategory + "</td>" +
"\n                                 <td itemprop='recipeCuisine' style='text-align:center; width:33%;'>" + recipeCuisine + "</td>" +
"\n                                 <td itemprop='recipeYield' style='text-align:center; width:33%;'>" + recipeYield + "</td>" +
"\n                             </tr>" +
"\n                         </table>" +
"\n <!-- /------------/ -->" +
"\n                         <hr>" +
"\n <!-- /------------/ -->" +
"\n                         <div itemprop='nutrition'>" +
"\n                             <strong>Nutrition Info:</strong> <span itemprop='calories'>" + nutritionCalories + "</span> // <strong>Servings:</strong> <span itemprop='servingSize'>" + nutritionServingSize + "</span>" + "</div>" +
"\n <!-- /------------/ -->" +
"\n                         <h4>INSTRUCTIONS:</h4>" +
"\n                         <div itemprop='recipeInstructions'>" + recipeInstructions + "</div>" +
"\n <!-- /------------/ -->" +
"\n                         <hr>" +
"\n <!-- /------------/ -->" +
"\n                         <h3>NOTES:</h3>" + recipeNotes +
"\n <!-- /------------/ -->" +
"\n         </div><!-- recipe right flexbox ends -->" +
"\n <!-- /------------/ -->" +
"\n      </div><!-- recipe main flexbox container ends -->" +
"\n <!-- /------------/ -->" +
"\n         <hr>" +
"\n <!-- /------------/ -->" +
"\n         <table border='0' cellpadding='1' cellspacing='5' width='100%'>" +
"\n             <tr>" +
"\n                 <td style='text-align:left; width:15%;'><img alt='Logo' height='70px' src='https://www.mygingergarlickitchen.com/wp-content/uploads/2015/02/mggk-new-logo-transparent-150px.png'>" +
"\n                 </td>" +
"\n <!-- /------------/ -->" +
"\n                 <td style='text-align:left;'>" +
"\n                     <strong>Author:</strong> <span itemprop='author'>" + recipeAuthor + "</span><br>" +
"\n                     <strong>Recipe Source Link:</strong> <a href='" + recipeUrl + "'><span itemprop='url'>" + recipeUrl + "</span></a><br>" +
"\n                     <strong>Date Published: </strong> <span itemprop='datePublished'>" + datePublished + "</span>" +
"\n                 </td>" +
"\n             </tr>" +
"\n         </table>" +
"\n <!-- /------------/ -->" +
"\n     </div>" +
"\n <!-- /------------/ -->" +
"\n </div>" +
"\n <!-- HTML RECIPE CODE BLOCK ABOVE THIS --> \n" ;
