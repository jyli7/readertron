module ApplicationHelper
  def bookmarklet_for_user(user)
    'javascript: var execute = function (text) { var xmlHttpReq=new XMLHttpRequest(); xmlHttpReq.open("POST","' + Domain.url + '/reader/create_post",true); xmlHttpReq.setRequestHeader("Content-Type","application/x-www-form-urlencoded"); var note = document.getElementById("readertron-textarea").value; var query=""; query+="&note="+note; query+="&type=regular"; query+="&url="+window.location.href; query+="&title="+document.getElementById("readertron-title").value; query+="&token=' + user.share_token + '"; query+="&content="+encodeURIComponent(text); xmlHttpReq.send(query); }; var text=window.getSelection(); var objRange=text.getRangeAt(0); var objClone=objRange.cloneContents(); var objDiv=document.createElement("div"); objDiv.appendChild(objClone); text=objDiv.innerHTML; var div = document.createElement("div"); div.id = "readertron-bookmarklet"; div.style.position ="fixed"; div.style.zIndex = "99999"; div.style.width = "500px"; div.style.height = "300px"; div.style.backgroundColor = "white"; div.style.border = "3px solid #B4CEFE"; div.style.top = "10px"; div.style.right = "10px"; var img = document.createElement("img"); img.src = "' + Domain.url + '/assets/logo-with-wordmark.png"; img.style.padding = "5px"; div.appendChild(img); var titlediv = document.createElement("div"); var title = document.createElement("input"); title.id = "readertron-title"; title.value = document.title; title.style.color = "#333"; title.style.fontSize = "18px"; title.style.fontFamily = "Helvetica, arial, sans-serif"; title.style.marginLeft = "50px"; title.style.width = "400px"; titlediv.appendChild(title); div.appendChild(titlediv); var contentdiv = document.createElement("div"); contentdiv.style.padding = "0px 0px 0px 5px"; contentdiv.style.height = "100px"; contentdiv.style.overflowY = "scroll"; contentdiv.style.margin = "0px 50px 0px 50px"; contentdiv.style.fontFamily = "arial, sans-serif"; contentdiv.style.fontSize = "12px"; contentdiv.style.color = "#333"; contentdiv.style.border = "1px solid #999"; contentdiv.innerHTML = text; div.appendChild(contentdiv); var form = document.createElement("form"); var textarea = document.createElement("textarea"); textarea.style.width = "400px"; textarea.style.height = "50px"; textarea.style.margin = "5px 0px 20px 50px"; textarea.style.padding = "5px"; textarea.id = "readertron-textarea"; var quotes = document.createElement("img"); quotes.src = "' + Domain.url + '/assets/bookmarklet-quotes.png"; quotes.style.position = "absolute"; quotes.style.top = "170px"; quotes.style.left = "20px"; div.appendChild(quotes); var closelink = document.createElement("a"); closelink.style.position = "absolute"; closelink.style.top = "10px"; closelink.style.right = "10px"; closelink.style.color = "#100F62"; closelink.onclick = function() { var c = document.getElementById("readertron-bookmarklet"); c.parentNode.removeChild(c); }; closelink.href = "#"; var closetext = document.createTextNode("Close this"); closelink.appendChild(closetext); div.appendChild(closelink); var submit = document.createElement("input"); submit.type = "submit"; submit.value = "Post Item"; submit.style.marginLeft = "50px"; submit.onclick = function() { execute(text) }; form.appendChild(textarea); form.appendChild(submit); div.appendChild(form); document.body.appendChild(div);'
  end

  def markdown(text)
    renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    clean(renderer.render(text))
  end
  
  def mdown(text)
    text = text.gsub(%r{(^|\s)([*_])(.+?)\2(\s|$)}x, %{\\1<em>\\3</em>\\4})
    text = text.gsub(/[\n]+/, "<br><br>")
    raw(text)
  end
  
  def comment_date(date)
    if date >= 1.month.ago
      date.strftime("(#{time_ago_in_words(date)} ago)")
    else
      date.strftime("(%b #{date.day}, %Y %I:%M %p)")
    end
  end
end