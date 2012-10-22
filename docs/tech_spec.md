# Teamarks Tech Spec
*作者：Void Main*

## Model
- User
	- id
	- username(nickname): string
	- email: string
	- password: string
- Team __AA__
	- id
	- teamname:string
- Url
	- id
	- url: string
	- page title: string
	- selected text: string
	- from: User
- Tag __AA__
	- id
	- name:string
## API
- POST /v1/share?source=user_id&url=XXXXX
	- {"success"}
	- {"error"}
- GET /v1/list?after=date_time
	- [{"user_id": "10001", "links":[{"url": "http://www.baidu.com", "page_title" : "百度"}, {"url": "http://www.google.com", "page_title" : "Google"}]}, …]
- GET /v1/user?id=XXXX
	- {"user_id": "10001", "nick_name": "gof", "email"":"gof@gmail.com"}

## Backend
- Rails
	- for api
	- email daemon

## UI & Frontend
- Chrome Plugin
- Mac Notificaiton Center __AA__
