# Graph.Refined

Graph.Refined is a simple function to remove null values from Graph cmdlets. 

## Examples

Use ```Refined``` in the pipeline to remove object properties which are empty.
```
Get-MgUser -All | Refined
```
Use ```-limit``` to further remove object properties which are not in String format.
```
Get-MgUser -All | Refined -limit
```