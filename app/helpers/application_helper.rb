module ApplicationHelper
  def bookmarklet_for_user(user)
    'javascript:var note=prompt("Add a note if you\'d like",""); var text=window.getSelection();var objRange=text.getRangeAt(0);var objClone=objRange.cloneContents();var objDiv=document.createElement(\'div\');objDiv.appendChild(objClone);text=objDiv.innerHTML;var xmlHttpReq=new XMLHttpRequest();xmlHttpReq.open(\'POST\',\'http://localhost:3000/reader/create_post\',true);xmlHttpReq.setRequestHeader(\'Content-Type\',\'application/x-www-form-urlencoded\');var query=\'\';query+="&note="+note;query+="&type=regular";query+="&url="+window.location.href;query+="&title="+document.title;query+="&token=' + user.share_token + '";query+="&content="+encodeURIComponent(text);query+="&format=markdown";xmlHttpReq.send(query)'
  end
end