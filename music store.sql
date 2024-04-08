select * from album;

select * from employee
order by levels desc
limit 1;

select count(*) count , billing_country country
from invoice
group by billing_country
order by count(*) desc;

select total from invoice 
order by total desc
limit 3;

select billing_city, sum(total) as invoices_total
from invoice
group by billing_city
order by invoices_total desc;

select c.customer_id, c.first_name, c.last_name, sum(i.total) as total
from invoice i
join customer c on c.customer_id=i.customer_id
group by c.customer_id
order by total desc
limit 1;

select distinct c.first_name, c.last_name, c.email
from customer c
join invoice i on i.customer_id=c.customer_id
join invoice_line il on il.invoice_id=i.invoice_id
where track_id in
	(select t.track_id
	from track t
	join genre g on g.genre_id=t.genre_id
	where g.name='Rock')
order by c.email;

select ar.artist_id, ar.name, count(t.track_id)
from artist ar
join album al on al.artist_id=ar.artist_id
join track t on t.album_id=al.album_id
where track_id in
	(select t.track_id
	from track t
	join genre g on g.genre_id=t.genre_id
	where g.name='Rock')
group by ar.artist_id
order by count(t.track_id) desc
limit 10;

select distinct name, milliseconds
from track
where milliseconds>(
	select avg(milliseconds) 
	from track)
order by milliseconds desc;

with best_selling_artist as(
SELECT artist.artist_id AS artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;


	
