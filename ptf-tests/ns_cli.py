import bfrtcli as cli

# from bfrt_grpc import client

from tofino.bfrt_grpc import client

class nano():
    def __init__(self) -> None:

        pass

netMod3 = cli.bfrt.netMod3

cli.bfrt._get_full_leaf_info()

grpc_client = client.ClientInterface(grpc_addr = "localhost:50052", client_id = 0, device_id = 0)
# bfrt = cli.bfrt.

# for c in bfrt._children:
#     print(c.name)
