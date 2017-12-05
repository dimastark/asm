import struct
import socketserver


class Store:
    def __init__(self):
        self.storage = {}
        self.commands = [
            self.list,
            self.set,
            self.get,
            self.delete,
            self.count
        ]

    def list(self):
        return list(self.storage.keys())

    def set(self, k, v):
        self.storage[k] = v

    def get(self, k):
        return [self.storage[k]]

    def delete(self, k):
        self.storage.pop(k)

    def count(self):
        return [str(len(self.list())).encode()]

    @staticmethod
    def _log(command, args):
        args_repr = ', '.join(repr(arg) for arg in args)
        print(f'Call {command.__name__}({args_repr})', end='')

    def exec(self, command_num, args):
        try:
            command = self.commands[command_num]
            self._log(command, args)
            return command(*args)
        except (IndexError, KeyError):
            return None


class RequestHandler(socketserver.BaseRequestHandler):
    STORE = Store()

    @staticmethod
    def _parse_args(data):
        pointer = 0
        args = []

        while pointer < len(data):
            arg_size, = struct.unpack('>I', data[pointer:pointer + 4])
            args.append(data[pointer + 4:pointer + 4 + arg_size])
            pointer += 4 + arg_size

        return args

    @staticmethod
    def _serialize_result(result):
        if not result:
            return b'\x00\x00'

        raw_data = b'\x00'
        raw_data += struct.pack('>B', len(result))

        for block in result:
            block_size = len(block)
            raw_data += struct.pack(f'>I{block_size}s', block_size, block)

        return raw_data

    def handle(self):
        try:
            raw_data = self.request.recv(32768).strip()
            command_num, args_count = struct.unpack('>BB', raw_data[:2])
            args = self._parse_args(raw_data[2:])
            result = self.STORE.exec(command_num, args)
            answer = self._serialize_result(result)
            print(f' -> {repr(answer)} Store: {repr(self.STORE.storage)}')
            self.request.sendall(answer)
        except struct.error:
            print('Format error')


if __name__ == '__main__':
    host, port = 'localhost', 31000

    with socketserver.TCPServer((host, port), RequestHandler) as server:
        print(f'Server listening on {port}')
        server.serve_forever()
