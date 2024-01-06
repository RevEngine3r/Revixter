from channels.generic.websocket import AsyncJsonWebsocketConsumer

from django.contrib.auth.models import User

USERS = dict()


class ChatConsumer(AsyncJsonWebsocketConsumer):
    def __init__(self, *args, **kwargs):
        super().__init__(args, kwargs)
        self.user = None

    async def connect(self):
        user = self.scope['user']
        self.user = user

        if not user.is_authenticated or user.is_anonymous:
            await self.close(403)
            print('User not authenticated.')
            return

        await self.accept()
        print(f'User {user.username} => {user.id}, logged in.')
        USERS.setdefault(user.id, []).append(self)

    async def disconnect(self, close_code):
        USERS[self.user.id].pop()
        print(f'User {self.user.username} => {self.user.id}, logged out.')

    async def receive_json(self, content=None, **kwargs):
        try:
            to = content['to']

            if type(to) is str:
                to = User.objects.get(username=to).id

            msg = content['msg'].decode('utf-8')
            content = {'from': self.user.id, 'msg': msg}

            for user in USERS[to]:
                await user.send_json(content)
        except Exception as e:
            print(e)
