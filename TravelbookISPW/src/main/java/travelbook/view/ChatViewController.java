package main.java.travelbook.view;

import java.time.Instant;
import java.util.List;
import main.java.travelbook.util.Observer;

import main.java.travelbook.util.Observable;

import exception.DBException;
import exception.MissingPageException;
import javafx.scene.input.KeyCode;
import javafx.application.Platform;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.geometry.Pos;
import javafx.scene.control.Button;
import javafx.scene.control.ButtonBar;
import javafx.scene.control.Label;
import javafx.scene.control.ListCell;
import javafx.scene.control.ListView;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.scene.input.KeyEvent;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.Pane;
import javafx.scene.layout.StackPane;
import javafx.scene.paint.Paint;
import javafx.scene.shape.Circle;
import javafx.scene.text.Text;
import main.java.travelbook.controller.ChatController;
import exception.TriggerAlert;
import main.java.travelbook.model.bean.MessageBean;
import main.java.travelbook.model.bean.UserBean;
import main.java.travelbook.util.Chat;
import main.java.travelbook.util.SetImage;

public class ChatViewController implements Observer{
	private Object[] array1=new Object[15];
	private Button button;
	private BorderPane mainPane;
	@FXML
	private Button send;
	@FXML
	private TextArea write;
	@FXML
	private AnchorPane mainAnchor;
	@FXML
	private AnchorPane chatAnchor;
	@FXML
	private StackPane writeBar;
	@FXML
	private ListView<MessageBean> sentList;
	@FXML
	private ListView<MyItem> contactList;
	@FXML
	private ButtonBar menuBar;
	@FXML
	private StackPane search;
	@FXML
	private Button searchButton;
	@FXML
	private TextField searchField;
	private UserBean searchedUser;
	private List<Chat> myChats = MenuBar.getInstance().getMyChat();
	private ChatController myController = new ChatController();
	private SearchUserTextField searchFieldAuto;
	private Chat current = null;
	private ObservableList<MyItem> contacts;
	private String changed = "changed";
	class MyItem {
		private StringProperty specialIndicator;
		private UserBean contact;
        MyItem(UserBean name) {
            this.contact = name;
            this.specialIndicator = new SimpleStringProperty();
            this.setSpecialIndicator("");
        }

        public UserBean getUser() {
            return this.contact;
        }

        public void setName(UserBean name) {
            this.contact = name;
        }

        public String getSpecialIndicator() {
            return specialIndicator.get();
        }

        public StringProperty specialIndicatorProperty() {
            return specialIndicator;
        }

        public void setSpecialIndicator(String specialIndicator) {
            this.specialIndicator.set(specialIndicator);
        }
    }
	
	public void initialize() {
		MenuBar.getInstance().addObserver(this);
	contactList.setItems(null);
	searchFieldAuto = new SearchUserTextField(searchField);
	searchFieldAuto.getLastSelectedItem().addListener((observable,oldValue,newValue)->{
		if(searchFieldAuto.getLastSelectedItem().get()!=null) 
			searchedUser = searchFieldAuto.getLastSelectedItem().get();
	});
	 sentList.setCellFactory(list -> new MessageCell());
	 List<UserBean> tryContacts;
	try {
		tryContacts = myController.getContacts(myChats,MenuBar.getInstance().getLoggedUser().getId());
	
		 contacts = FXCollections.observableArrayList();
	 for(UserBean u: tryContacts) {
		 contacts.add(new MyItem(u));
		 
	 }
	 for(Chat c:myChats)
		 if(c.isChanged())
			 notified(c);
    
	contactList.setItems(contacts);
	} catch (DBException e) {
		new TriggerAlert().triggerAlertCreate(e.getLocalizedMessage(), "warn").showAndWait();
	}
	contactList.getSelectionModel().selectedItemProperty().addListener((observable, oldValue, newValue) -> { 
		if(contactList.getSelectionModel().getSelectedIndex()!=-1) {
			MyItem user = contactList.getItems().get(contactList.getSelectionModel().getSelectedIndex());
            select(user);
			changeChat();
		}
    });
	contactList.setCellFactory(list -> new ContactCell());
	 
	 
	
	}
	
	private void select(MyItem user) {
		user.setSpecialIndicator("selected");
		for(MyItem u: contacts) {
			if(u!=user && !u.getSpecialIndicator().equalsIgnoreCase(changed))
				u.setSpecialIndicator("");
		}
		contactList.refresh();
		int i = 0;
		current = null;
		while(i<myChats.size() && current == null) {
			if(myChats.get(i).getIdUser()==user.getUser().getId())
				current = myChats.get(i);
			i++;
		}
		if(current == null) {
			current = new Chat(user.getUser().getId());
			myChats.add(current);
		}
	}
	 class MessageCell extends ListCell<MessageBean>{
		@Override
        public void updateItem(MessageBean item, boolean empty) {
            super.updateItem(item, empty);
            if (item != null) {
            	HBox hBox = new HBox();
            	if(item.getIdMittente()!=MenuBar.getInstance().getLoggedUser().getId()) {
            		hBox.setAlignment(Pos.BASELINE_LEFT);
            	}
            	else {
            		hBox.setAlignment(Pos.BASELINE_RIGHT);
            	}
                // Create centered Label
                Label label = new Label(item.getText());
                label.setWrapText(true);
                label.setMaxWidth((chatAnchor.getPrefWidth()-(1.0/5)*chatAnchor.getPrefWidth())/2);
                label.setAlignment(Pos.CENTER);

                hBox.getChildren().add(label);
                setGraphic(hBox);
            }
            else
            	setGraphic(null);
        }
	}
	class ContactCell extends ListCell<MyItem>{
		@Override
		public void updateItem(MyItem item, boolean empty) {
			super.updateItem(item, empty);
			if(!empty) {
				HBox hBox = new HBox();
				hBox.setSpacing(mainAnchor.getPrefWidth()*10/1280);
				hBox.getStyleClass().add("h-box");
				hBox.setAlignment(Pos.CENTER);
				
				if(item.getSpecialIndicator().equalsIgnoreCase("selected")) {
					hBox.getStyleClass().add("h-box-selected");
				}
				
				Text contact = new Text(item.getUser().getName()+" "+item.getUser().getSurname());
				contact.getStyleClass().add("text");
				contact.setWrappingWidth(mainAnchor.getPrefWidth()*150/1280);
				Pane contactPic = new Pane();
				new SetImage(contactPic, item.getUser().getPhoto(), false);
				contactPic.setPrefHeight(mainAnchor.getPrefHeight()*70/625);
				contactPic.setPrefWidth(mainAnchor.getPrefWidth()*70/1280);
				mainAnchor.widthProperty().addListener((observable,oldValue,newValue)->{
					contactPic.setPrefWidth(mainAnchor.getPrefWidth()*70/1280);
					hBox.setSpacing(mainAnchor.getPrefWidth()*10/1280);
					contact.setWrappingWidth(mainAnchor.getPrefWidth()*170/1280);
				});
				mainAnchor.heightProperty().addListener((observable,oldValue,newValue)->
					contactPic.setPrefHeight(mainAnchor.getPrefHeight()*70/625)
				);
				
				hBox.getChildren().add(contactPic);
				hBox.getChildren().add(contact);
				if(item.getSpecialIndicator().equalsIgnoreCase(changed)) {
					hBox.getChildren().add(new Circle(5, Paint.valueOf("rgb(255, 162, 134)")));
				}
				setGraphic(hBox);
			}
			else {
				setGraphic(null);
			}
		}
	}
	
	private void changeChat() {
		List<MessageBean>  myMessages;
		if(current.getReceive()!=null) {
			for(MessageBean m:current.getReceive()) {
				if(!m.getRead()) {
					m.setRead(true);
					try {
						myController.setReadMex(m);
					} catch (DBException e) {
						new TriggerAlert().triggerAlertCreate(e.getMessage(), "warn").showAndWait();
					}
				}
			}
		}
		myMessages = myController.getMessages(current.getReceive(), current.getSend());
		if(myMessages!=null) {
			ObservableList<MessageBean> data = FXCollections.observableArrayList(myMessages);
			sentList.setItems(data); 
			sentList.scrollTo(data.size());
		}
		else {
			sentList.setItems(null);
		}
	}
	public void setMainPane(BorderPane main) {
		this.mainPane=main;
		//then define the resize logic
		this.mainPane.getScene().getWindow().heightProperty().addListener((observable,oldValue,newValue)->
			mainPane.setPrefHeight(this.mainPane.getScene().getWindow().getHeight()));
		this.mainPane.getScene().getWindow().widthProperty().addListener((observable,oldValue,newValue)->
			mainPane.setPrefWidth(mainPane.getScene().getWindow().getWidth())); 
		this.mainPane.heightProperty().addListener((observable,oldValue,newValue)->{
			StackPane title=(StackPane)mainPane.getTop();
			title.setPrefHeight(mainPane.getHeight()*94/720);
			mainAnchor.setPrefHeight(mainPane.getHeight()*625/720);
			
		});
		this.mainPane.widthProperty().addListener((observable,oldValue,newValue)->
			mainAnchor.setPrefWidth(mainPane.getWidth())
		);
		this.mainAnchor.heightProperty().addListener((observable,oldValue,newValue)->{
	
			chatAnchor.setPrefHeight(mainAnchor.getPrefHeight()*517/625);
			chatAnchor.setLayoutY(mainAnchor.getPrefHeight()*96/625);
			sentList.setPrefHeight(mainAnchor.getPrefHeight()*433/625);
			
			writeBar.setPrefHeight(mainAnchor.getPrefHeight()*85/625);
			writeBar.setLayoutY(mainAnchor.getPrefHeight()*432/625);
			write.setPrefHeight(mainAnchor.getPrefHeight()*70/625);
			send.setPrefHeight(mainAnchor.getHeight()*30/625);
			contactList.setPrefHeight(mainAnchor.getHeight()*450/625);
			contactList.setLayoutY(mainAnchor.getHeight()*107/625);
			search.setPrefHeight(mainAnchor.getHeight()*50/625);
			search.setLayoutY(mainAnchor.getHeight()*557/625);
			searchButton.setPrefHeight(mainAnchor.getHeight()*40/625);
			searchField.setPrefHeight(mainAnchor.getHeight()*40/625);
			menuBar.setPrefHeight(mainAnchor.getHeight()*85/625);
			menuBar.setLayoutY(0);
			array1=menuBar.getButtons().toArray();
			for(int i=0;i<4;i++) {
				button=(Button)array1[i];
				button.setPrefHeight(mainAnchor.getHeight()*56/625);
			}
		});	
		this.mainAnchor.widthProperty().addListener((observable,oldValue,newValue)->{
			chatAnchor.setPrefWidth(mainAnchor.getPrefWidth()*904/1280);
			chatAnchor.setLayoutX(mainAnchor.getPrefWidth()*350/1280);
			sentList.setPrefWidth(mainAnchor.getPrefWidth()*904/1280);
			
			writeBar.setPrefWidth(mainAnchor.getPrefWidth()*904/1280);
			write.setPrefWidth(mainAnchor.getPrefWidth()*750/1280);
			send.setPrefWidth(mainAnchor.getWidth()*40/1280);
			contactList.setPrefWidth(mainAnchor.getWidth()*300/1280);
			contactList.setLayoutX(mainAnchor.getWidth()*33/1280);
			search.setPrefWidth(mainAnchor.getWidth()*300/1280);
			search.setLayoutX(mainAnchor.getWidth()*33/1280);
			searchButton.setPrefWidth(mainAnchor.getWidth()*40/1280);
			searchField.setPrefWidth(mainAnchor.getWidth()*250/1280);
			menuBar.setPrefWidth(mainAnchor.getWidth()*592/1280);
			menuBar.setLayoutX(0);
			array1=menuBar.getButtons().toArray();
			for(int i=0;i<4;i++) {
				button=(Button)array1[i];
				button.setPrefWidth(mainAnchor.getWidth()*147/1280);
			}
		});
		
		
		this.mainAnchor.setPrefHeight(mainPane.getHeight()*625/720);
		this.mainAnchor.setPrefWidth(mainPane.getWidth());
		
		write.setOnKeyPressed(this::keyPressed);
	}
	private void keyPressed(KeyEvent evt) {
		//per qualche motivo va anche a capo dopo aver inviato, risolvere
		KeyCode ch = evt.getCode();
		if(ch.equals(KeyCode.ENTER)){
			sendHandler();
		}
	}
	
	@FXML
    private void profileHandler(){
    	try {
    	MenuBar.getInstance().moveToProfile(mainPane);
    	}catch(MissingPageException e) {
    		e.exit();
    	}
    }
    @FXML
    private void exploreHandler() {
    	try {
    		MenuBar.getInstance().moveToExplore(mainPane);
    	}catch(MissingPageException e) {
    		e.exit();
    	}
    }
    @FXML
    private void addHandler() {
    	try {
    		MenuBar.getInstance().moveToAdd(mainPane);
    	}catch(MissingPageException e) {
    		e.exit();
    	}
    }

    @FXML
    private void sendHandler() {
    	MessageBean newMsg = new MessageBean(current.getIdUser(), MenuBar.getInstance().getLoggedUser().getId());
    	newMsg.setText(write.getText());
    	newMsg.setTime(Instant.now());
    	newMsg.setRead(false);
    	sentList.getItems().add(newMsg);
    	current.getSend().add(newMsg);
    	try {
			myController.sendMessage(newMsg);
		} catch (DBException e) {
			new TriggerAlert().triggerAlertCreate(e.getMessage(), "warn").showAndWait();
		}
    	write.clear();
    	sentList.scrollTo(sentList.getItems().size());
    }
  @FXML
    private void searchHandler() {
	  	  try{
	  		  	if(searchFieldAuto.getTextField().getText()!= null) {
		
		  		MyItem i = new MyItem(searchedUser);
		  
			  	searchFieldAuto.getTextField().setText(null);
			  	int j=0;
			  	boolean found = false;
			  	while(j<contactList.getItems().size() && !found) {
			  		if(contactList.getItems().get(j).getUser().getId()==i.getUser().getId()) {
			  			contactList.getSelectionModel().select(contactList.getItems().get(j));
			  			contactList.scrollTo(contactList.getItems().get(j));
			  			found = true;
			  		}
			  		j++;
			  	}
			  	if(!found) {
			  		contactList.getItems().add(i);
			  		contactList.getSelectionModel().select(i);
			  		contactList.scrollTo(i);
			  	}	
		  	}
	  	}catch(NullPointerException e) {
	  		new TriggerAlert().triggerAlertCreate("Select a valid User from Autocomplete", "warn").showAndWait();
	  	}
    	
    }

@Override
public void update(Observable bar, Object notify) {
	boolean value=(Boolean)notify;
	if(value) {
		Platform.runLater(()->{
			for(Chat c: myChats) {
				if(c.isChanged()) {
					notified(c);
					if(current == c){
						changeChat();
					}
				}
			}
		});
		
	}
	
}
public void notified(Chat c) {
	for(MyItem u: contacts) {
		if(u.getUser().getId()==c.getIdUser())
			u.setSpecialIndicator("changed");
	}
}

@Override
public void update(Observable bar) {
	this.update(bar,true);
	
}


}
