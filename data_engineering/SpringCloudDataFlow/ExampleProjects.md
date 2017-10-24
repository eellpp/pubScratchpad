Example

## Cloud Stream Demo Project

An example store a set of newly registered customers. 

- source : list of customer purchases, as individual records

```bash
{id:johndoe,items:[ { cat:"milk",brand:"Cowa",cost:2.45}, {cat:"bread",brand:"bakerA",cost:1.55}, ...]}
```
- processor : Based on purchase analysis, makes recommendations
```bash
{id:johndoe,
items:[ { cat:"milk",brand:"Cowa",cost:2.45}, {cat:"bread",brand:"bakerA",cost:1.55}, ...], 
rec : ["cowA Cheese at 20 % discount and a free bakerB doughnut"]
}
```
- sink : saves the invoice and email it to customer with recommendation


## Cloud compose Demo Project
- "create an invoice and save it to file" && "create email with product recommendation"
- email recommendation and invoice
