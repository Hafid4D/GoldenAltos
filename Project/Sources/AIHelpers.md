Une **entrée SFW** est créée principalement via une fonction `entryDefinition()` dans la classe de la dataclass (ex: `Customer`).

Exemple réel `Customer` :

```4:14:Project/Sources/Classes/Customer.4dm
local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	//Mark: entry : Customer
	$entry:=cs:C1710.sfw_definitionEntry.new("customer"; ["customerService"]; "Customers")
	$entry.setDataclass("Customer")
	$entry.setDisplayOrder(100)
	$entry.setIcon("image/entry/customers-white-50x50.png")
	
	$entry.setSearchboxField("name")
	
	$entry.setPanel("panel_customer")
```

Puis tu configures les pages/colonnes/actions/filtres/vues :

```23:32:Project/Sources/Classes/Customer.4dm
$entry.setLBItemsColumn("codeNumber"; "Code"; "xliff:entry.customer.field.name"; "width:80")
$entry.setLBItemsColumn("name"; "Name"; "xliff:entry.customer.field.name"; "width:200")

$entry.setItemAction("Generate Barcode"; "_ga_openBarCodeForm")
$entry.setItemListAction("Search by Scanning"; "_ga_searchByBarcodeScanning")

$entry.setLBItemsOrderBy("name")
```

## Ce qu’il faut pour qu’une entrée fonctionne

- `entryDefinition()` dans la classe dataclass (`Customer.4dm`, `Lot.4dm`, etc.).
- `setDataclass("...")` doit matcher le nom exact de la dataclass.
- `setPanel("panel_xxx")` doit pointer vers un form existant (`Forms/panel_xxx/form.4DForm`) + son `method.4dm`.
- Le module/vision (`"customerService"` ici) doit exister dans la définition globale des visions.

Vision `customerService` existe ici :

```209:214:Project/Sources/Classes/goldenAltos_definition.4dm
$vision:=cs:C1710.sfw_definitionVision.new("customerService"; "Customer service")
$vision.setToolbarBackgroundColor("#52ABD8")
$vision.setFocusRingColor("navy")
$vision.setIcon("image/vision/customer-service-24x24.png")
This:C1470._push_vision($vision)
```

## Important 
Il y'a aussi un autre mécanisme dans `goldenAltos_definition._entries_definition()` (ex: `punchIn`, `punchOut`, `receiver`) qui crée des entrées “manuellement”.  
Donc dans ce projet, il y a **2 patterns** :

- pattern dataclass (`Customer.entryDefinition`)  
- pattern global (`goldenAltos_definition._entries_definition`)

 

## Pattern global d’une entrée

1. **La dataclass définit l’entrée** via `entryDefinition()`
2. **L’entrée pointe vers un panel** (`setPanel("panel_xxx")`)
3. **Le form panel délègue sa logique** à une classe singleton `panel_xxx`
4. **La classe panel_xxx** applique le cycle SFW (`panelFormMethod`, update, page recalculation, redraw)
5. **Le form panel_xxx** contient objets UI + bindings `Form.current_item...` + object methods

---

## 1) Pattern `entryDefinition()` (dans la dataclass)

C’est le modèle que tu veux reproduire.

```4:14:Project/Sources/Classes/Customer.4dm
local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	//Mark: entry : Customer
	$entry:=cs:C1710.sfw_definitionEntry.new("customer"; ["customerService"]; "Customers")
	$entry.setDataclass("Customer")
	$entry.setDisplayOrder(100)
	$entry.setIcon("image/entry/customers-white-50x50.png")
	
	$entry.setSearchboxField("name")
	
	$entry.setPanel("panel_customer")
```

Ensuite: pages / colonnes LB / actions / tri / filtres / vues.

---

## 2) Pattern `Forms/panel_xxx/method.4dm`

Toujours ultra court: délégation vers classe panel.

```1:1:Project/Sources/Forms/panel_customer/method.4dm
cs:C1710.panel_customer.me.formMethod()
```

Même pattern sur `panel_receiver`.

---

## 3) Pattern `Classes/panel_xxx.4dm` (cycle de vie)

Le cœur est toujours le même :

```4:12:Project/Sources/Classes/panel_customer.4dm
Function formMethod()
	Form:C1466.sfw.panelFormMethod()
	If (Form:C1466.sfw.updateOfPanelNeeded())
		...
	End if
```

Puis 3 blocs standards :
- `updateOfPanelNeeded()` : init/reset quand item change
- `recalculationOfPanelPageNeeded()` : charger données page active
- `redrawAndSetVisibleInPanelNeeded()` : resize/visibilité/labels dynamiques

`panel_customer` et `panel_receiver` suivent exactement ça.

---

## 4) Pattern du `form.4DForm` panel

### a) Base commune
- `inheritedForm: "sfw_bkgd_header_3lines"`
- multi-pages (onglets)
- bindings vers `Form:C1466.current_item...`

### b) Objets “métier”
- `input` liés à `Form.current_item`
- `listbox` liés à collections (`Form.lb_xxx`)
- `subform` pour composants (date picker, adresse...)
- beaucoup d’`ObjectMethods/*.4dm` pour actions ciblées

Exemples observés:
- `panel_customer`: subform adresse + listboxes PO/Jobs/Planning/CFM/Invoices
- `panel_receiver`: fiches lot + date pickers en subforms + listbox matériaux

---

## Canevas minimal réutilisable (entrée + panel)

- **Dataclass** `Xxx.4dm`:
  - `entryDefinition()`
  - `new("xxx"; ["vision"]; "Label")`
  - `setDataclass("Xxx")`
  - `setPanel("panel_xxx")`
  - `setPanelPage(1; ""; "Main")`
  - `setLBItemsColumn(...)`
  - `setLBItemsOrderBy(...)`
- **Classe panel** `panel_xxx.4dm`:
  - singleton constructor
  - `formMethod()` avec 3 blocs SFW standard
  - `redrawAndSetVisible()`
  - `loadMain()/loadPageN()`
- **Form panel** `Forms/panel_xxx/`:
  - `method.4dm` = délégation classe
  - `form.4DForm` avec `inheritedForm` + bindings `Form.current_item`

---

