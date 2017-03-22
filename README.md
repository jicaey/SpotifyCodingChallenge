# SpotifyCodingChallenge
Client/Server creation
<h4>To see my server code please visit:https://shielded-gorge-22087.herokuapp.com/main</h4>
<table width="609" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td>
<p>How I met the requirements:</p>
<ul>
<li>Make a GET request to /people
<ul>
<li>&nbsp;When the application loads, a GET request is performed, displaying the results in the UI in JSON format. Manually visiting the /people endpoint will yield the same results</li>
</ul>
</li>
<li>Make a POST request to /people
<ul>
<li>This endpoint accepts Post requests of the application/json content-type.&nbsp;
<ul>
<li>Using keys "name" and "favoritecity"</li>
<li>A User ID will be generated automatically</li>
</ul>
</li>
</ul>
</li>
<li>Make a GET request to retrieve the object created in the previous request
<ul>
<li>The Client performs this by storing the userID generated in the previous step and passing it as a routing parameter.</li>
</ul>
</li>
<li>Make a PUT request to /people and modify the attribute city to be &ldquo;Brooklyn&rdquo;
<ul>
<li>A GET request is performed first allowing you to choose which entry you would like to modify in the client.</li>
</ul>
</li>
<li>Make a GET request to /people/1
<ul>
<li>This step attempts to retrieve the entry with "1" as the userID. An error is thrown if it is not found.</li>
</ul>
</li>
<li>Make a DELETE request to /people/1
<ul>
<li>Similar to the previous step, a DELETE attempt is made for userID "1".</li>
</ul>
</li>
<li>Make a GET request to /people
<ul>
<li>Exactly like the first step a GET request is performed fetching the full contents of the database table. The results print in the UI allowing you to see the changes to the database.</li>
</ul>
</li>
</ul>
</td>
</tr>
</tbody>
</table>
