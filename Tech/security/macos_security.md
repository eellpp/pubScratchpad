### Disable SSH password login
To prevent authentication without a public key, search for each of these in /etc/ssh/sshd_config, uncomment them, and set them to 'no':

PasswordAuthentication no  
ChallengeResponseAuthentication no  
UsePAM no  

To restart sshd (which is required to have it reread the config file), use  
sudo launchctl stop com.openssh.sshd  
sudo launchctl start com.openssh.sshd  

### Enable firewall
https://support.apple.com/en-gb/guide/mac-help/mh34041/mac  
 
On your Mac, choose Apple menu  > System Preferences, click Security & Privacy , then click Firewall.

If the lock at the bottom left is locked , click it to unlock the preference pane.

Click Firewall Options.

If the Firewall Options button is disabled, first click Turn On Firewall to turn on the firewall for your Mac.

Click the Add button  under the list of services, then select the services or apps you want to add. After an app is added, click its up and down arrows  to allow or block connections through the firewall.

Blocking an app’s access through the firewall could interfere with or affect the performance of the app or other software that may depend on it.

Important: Certain apps that don’t appear in the list may have access through the firewall. These can include system apps, services and processes, as well as digitally signed apps that are opened automatically by other apps. To block access for these programs, add them to the list.

When your Mac detects an attempt to connect to an app you haven’t added to the list and given access to, an alert message appears asking if you want to allow or deny the connection over the network or internet. Until you take action, the message remains and any attempts to connect to the app are denied.
