<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>
<html>
<head>
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
            <div class="menu-bar">
                <input type="button", class="button", name="profile", value="PROFILE">
                <input type="button", class="button", name="add", value="ADD">
                <input type="button", class="button", name="explore", value="EXPLORE">
                <input type="button", class="button p-button", name="chat", value="CHAT">
            </div>
            <div class="contact">

            </div>
            <div class="search">
                <input type="search", class="textfield", id="search-bar">
            </div>
        </div>
        <div class="panel chat-panel">
            <div class="chat">

            </div>
            <div class="write">
                <textarea class="textfield", id="write-bar", wrap="hard"></textarea>
                <input type="button", id="send">
            </div>
        </div>