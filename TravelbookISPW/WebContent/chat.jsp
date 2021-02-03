<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
     <!-- <%@page errorPage="errorpage.jsp" %> -->
<%@ page import="main.java.travelbook.util.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.Instant"%>
<%@ page import="main.java.travelbook.model.bean.*" %>
<%@ page import="main.java.travelbook.model.*" %>
<%@ page import="main.java.travelbook.controller.ChatController" %>
<%
	ChatController myController=new ChatController();
	List <Chat> c=new ArrayList<>();
	UserBean log=(UserBean)request.getSession().getAttribute("loggedBean");
	List<UserBean> tryContacts=new ArrayList<>();
	if(request.getSession().getAttribute("ChatList")!=null){ 
		c=(List<Chat>) request.getSession().getAttribute("ChatList");	
		tryContacts = myController.getContacts(c,log.getId());
	}
	int selettore=-1;
	
	for(int j=0;j<tryContacts.size();j++)
    {
    	if(request.getParameter("contatto"+j)!=null) {
    		selettore=j;
    		request.getSession().setAttribute("selettore",j);
    	}
    	
    }
	if(request.getParameter("invioMex")!=null)
	{
		if(request.getSession().getAttribute("selettore")!=null)
		{
			int index= (Integer) request.getSession().getAttribute("selettore");
			int id=tryContacts.get(index).getId();
			MessageBean messagge= new MessageBean(id,log.getId());
	        
	        StringBuffer text = new StringBuffer(request.getParameter("mex"));
	        
	        int loc = (new String(text)).indexOf('\n');
	        while(loc > 0){
	            text.replace(loc, loc+1, "<BR>");
	            loc = (new String(text)).indexOf('\n');
	       }
	       messagge.setText(text.toString()); 
	       messagge.setRead(false);
		   messagge.setTime(Instant.now());
		   myController.sendMessage(messagge);
		}
	}
%>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">  
    <script src="js\jquery.min.js"></script> 
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>  
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    
	<script type="text/javascript">
	var selected=0;

	function goToExplore()
	{
		  location.replace("explore.jsp");
	}
	function goToProfile()
	{
		  location.replace("profile.jsp");
	}
	function goToAdd()
	{
		  location.replace("add.jsp");
	}
	function createChat()
	{
		
	}
	function log( message ) {
			 $('#contact').append(
					    $('<div>').prop({
					      id: 'innerdiv',
					      innerHTML: message,
					      className: 'border pad'
					    })
					  );
			    }
	 $(function(){
		 
		 $('#search-bar').autocomplete(
	             {
		           	 position:{ my: "left top", at: "left bottom", collision: "none" },
		           	 minlength:1,
		             source:function(request,response)
		             {
			          		$.ajax({
			                 url:"autocompleteUser.jsp",
			                 method:"get",
			                 dataType:"json",
			                 data:{search:request.term},
			                 success:function(data)
			                 {
			                	 response(data);
			                	 log(data.user0);
			                 }
		             		});
		             }
	             });   
            }); 
	</script>
	<meta charset="ISO-8859-1">
    <link rel="stylesheet" href="css/loginCss.css">
    <link rel="stylesheet" href="css/chat.css">
	<title>Travelbook</title>
	
</head>
<body>
    <div class="header">
        <p class="title">
            Travelbook
        </p>
        <p class="subtitle">
            Wherever you go, go with all your heart
        </p>
    </div>
    <div class="anchor">
     <div class="panel contact-panel">
            <form action="chat.jsp" class="menu-bar">
                <input type="button" class="button" name="profile" value="PROFILE" onclick=goToProfile()>
                <input type="button" class="button" name="add" value="ADD" onclick=goToAdd()>
                <input type="button" class="button" name="explore" value="EXPLORE" onclick=goToExplore()>
                <input type="button" class="button p-button" name="chat" value="CHAT">
            </form>
            <div class="contact" id=contact>
				<%
				int i=0;
				for(UserBean contact:tryContacts)
				{
					int idC=contact.getId();
					%>
					<form id=<%=idC %> action="chat.jsp" method="post">
						<input type="submit" name=contatto<%=String.valueOf(i)%>>
						<p><%=contact.getName()%> <%=contact.getSurname()%><br>
					</form>			
			
				<%
				i++;
				}
				%>
					
				
            </div>
            <div class="search ui-widget">
                <input type="search" class="textfield" id=search-bar>
                <input type="Button" id=invia onclick=createChat() >
            </div>
        </div>
        <div class="panel chat-panel">
            <div class="chat">
            <%
				if(request.getSession().getAttribute("selettore")!=null)
				{	
					selettore=(Integer) request.getSession().getAttribute("selettore");
					int j=0;
					int x=0;
					for(Chat chat:c)
					{
						if(chat.getIdUser()== tryContacts.get(selettore).getId()) x=j;
						j++;
					}
					List<MessageBean> msgS=  c.get(x).getSend();
					List<MessageBean> msgR= c.get(x).getReceive();
					List<MessageBean> m= myController.getMessages(msgR, msgS);
					for(MessageBean messaggio:m)
					{
						if(messaggio.getIdDestinatario()==c.get(x).getIdUser()){
							%>
							<div>
								<p Style="background-color:red"><%=messaggio.getText()%><br>
							</div>
							<%
						}
						else{
							%>
							<div>
								<p Style="background-color:blue"><%=messaggio.getText()%><br>
							</div>
							<%
						}
					}
					
				}
		%>
            </div>
            <form class="write" action="chat.jsp" method="get">
                <textarea class="textfield" name=mex id=write-bar wrap="hard"></textarea>
                <input type="submit" name=invioMex>
            </form>
        </div>
   </div>