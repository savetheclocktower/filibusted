
(function() {
  
  function _stripeTable(table) {
    console.log(table);
    var tbodies = table.select("tbody");    
    var rows;
    for (var i = 0, tbody; tbody = tbodies[i]; i++) {
      rows = tbody.rows;
      for (var j = 0, row; row = rows[j]; j++) {
        var currentClass = row.className.replace('odd', '');
        currentClass += (j % 2 == 0) ? '' : 'odd';
        row.className = currentClass;
      }
    }
  }
  
  function _stripeTables() {
    $$(".data-table > table").each(_stripeTable);
  }
  
  
  document.observe("dom:loaded", _stripeTables);  
})();