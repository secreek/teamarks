## Teamarks Clients for OS X

### Creating a Sharing Service

- Requires Safari 6 and Mountain Lion
- Register the service to the system menu
- Post the current URL and title to Teamarks Web Service
- Include selected text in web page if applicable

#### Sample Screenshot
![share](http://deepakkeswani.com/wp-content/uploads/2012/09/Share_Options_in_Safari.png)

Read the [tech spec](tech_spec.md) and the [fucking code](../../) for API.

Ref: [NSSharingService Class Reference](https://developer.apple.com/library/mac/#documentation/AppKit/Reference/NSSharingService_Class/Reference/Reference.html#//apple_ref/doc/uid/TP40012270)

### Creating a System Service

- Capture a piece of selected text in any document
- Find (the first) URL in the text
- Use text before URL as param `title`
- Use text after URL as param `text`
- Show a simple form before posting
- Provide appropriate feedbacks inside the GUI

Bounds Features:

- Add an icon to top system menu
- User clicks the icon to open an empty form for quick custom post

#### Sample Screenshot

![services](http://www.peachpit.com/ShowBlogFile.aspx?f=1103&b=854465a0-86fc-4ddc-9281-2877f284ee9f)
#### Example:

##### Selected Text

Safari Books Online (www.safaribooksonline.com) is an on-demand digital library that delivers expert content in both book and video form from the world’s leading authors in technology and business.

##### Result

- `Title` => Safari Books Online
- `URL` => www.safaribooksonline.com *(The tricky part)*
- `Text` => is an on-demand digital library that delivers expert content in both book and video form from the world’s leading authors in technology and business.

Ref: [Services Implementation Guide](https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/SysServices/introduction.html#//apple_ref/doc/uid/10000101-SW1)



