
import tinyos.message.Message

# The default size of this message type in bytes.
DEFAULT_MESSAGE_SIZE = 10

# The Active Message type associated with this message.
AM_TYPE = 6

class TrackingMsg(tinyos.message.Message.Message):
    # Create a new TrackingMsg of size 10.
    def __init__(self, data="", addr=None, gid=None, base_offset=0, data_length=10):
        tinyos.message.Message.Message.__init__(self, data, addr, gid, base_offset, data_length)
        self.amTypeSet(AM_TYPE)
    
    # Get AM_TYPE
    def get_amType(cls):
        return AM_TYPE
    
    get_amType = classmethod(get_amType)
    
    #
    # Return a String representation of this message. Includes the
    # message type name and the non-indexed field values.
    #
    def __str__(self):
        s = "Message <TrackingMsg> \n"
        try:
            s += "  [nodeid=0x%x]\n" % (self.get_nodeid())
        except:
            pass
        try:
            s += "  [type=0x%x]\n" % (self.get_type())
        except:
            pass
        try:
            s += "  [distance10000=0x%x]\n" % (self.get_distance10000())
        except:
            pass
        try:
            s += "  [x=0x%x]\n" % (self.get_x())
        except:
            pass
        try:
            s += "  [y=0x%x]\n" % (self.get_y())
        except:
            pass
        return s

    # Message-type-specific access methods appear below.

    #
    # Accessor methods for field: nodeid
    #   Field type: int
    #   Offset (bits): 0
    #   Size (bits): 16
    #

    #
    # Return whether the field 'nodeid' is signed (False).
    #
    def isSigned_nodeid(self):
        return False
    
    #
    # Return whether the field 'nodeid' is an array (False).
    #
    def isArray_nodeid(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'nodeid'
    #
    def offset_nodeid(self):
        return (0 / 8)
    
    #
    # Return the offset (in bits) of the field 'nodeid'
    #
    def offsetBits_nodeid(self):
        return 0
    
    #
    # Return the value (as a int) of the field 'nodeid'
    #
    def get_nodeid(self):
        return self.getUIntElement(self.offsetBits_nodeid(), 16, 1)
    
    #
    # Set the value of the field 'nodeid'
    #
    def set_nodeid(self, value):
        self.setUIntElement(self.offsetBits_nodeid(), 16, value, 1)
    
    #
    # Return the size, in bytes, of the field 'nodeid'
    #
    def size_nodeid(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'nodeid'
    #
    def sizeBits_nodeid(self):
        return 16
    
    #
    # Accessor methods for field: type
    #   Field type: int
    #   Offset (bits): 16
    #   Size (bits): 16
    #

    #
    # Return whether the field 'type' is signed (False).
    #
    def isSigned_type(self):
        return False
    
    #
    # Return whether the field 'type' is an array (False).
    #
    def isArray_type(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'type'
    #
    def offset_type(self):
        return (16 / 8)
    
    #
    # Return the offset (in bits) of the field 'type'
    #
    def offsetBits_type(self):
        return 16
    
    #
    # Return the value (as a int) of the field 'type'
    #
    def get_type(self):
        return self.getUIntElement(self.offsetBits_type(), 16, 1)
    
    #
    # Set the value of the field 'type'
    #
    def set_type(self, value):
        self.setUIntElement(self.offsetBits_type(), 16, value, 1)
    
    #
    # Return the size, in bytes, of the field 'type'
    #
    def size_type(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'type'
    #
    def sizeBits_type(self):
        return 16
    
    #
    # Accessor methods for field: distance10000
    #   Field type: int
    #   Offset (bits): 32
    #   Size (bits): 16
    #

    #
    # Return whether the field 'distance10000' is signed (False).
    #
    def isSigned_distance10000(self):
        return False
    
    #
    # Return whether the field 'distance10000' is an array (False).
    #
    def isArray_distance10000(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'distance10000'
    #
    def offset_distance10000(self):
        return (32 / 8)
    
    #
    # Return the offset (in bits) of the field 'distance10000'
    #
    def offsetBits_distance10000(self):
        return 32
    
    #
    # Return the value (as a int) of the field 'distance10000'
    #
    def get_distance10000(self):
        return self.getUIntElement(self.offsetBits_distance10000(), 16, 1)
    
    #
    # Set the value of the field 'distance10000'
    #
    def set_distance10000(self, value):
        self.setUIntElement(self.offsetBits_distance10000(), 16, value, 1)
    
    #
    # Return the size, in bytes, of the field 'distance10000'
    #
    def size_distance10000(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'distance10000'
    #
    def sizeBits_distance10000(self):
        return 16
    
    #
    # Accessor methods for field: x
    #   Field type: short
    #   Offset (bits): 48
    #   Size (bits): 16
    #

    #
    # Return whether the field 'x' is signed (False).
    #
    def isSigned_x(self):
        return False
    
    #
    # Return whether the field 'x' is an array (False).
    #
    def isArray_x(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'x'
    #
    def offset_x(self):
        return (48 / 8)
    
    #
    # Return the offset (in bits) of the field 'x'
    #
    def offsetBits_x(self):
        return 48
    
    #
    # Return the value (as a short) of the field 'x'
    #
    def get_x(self):
        return self.getSIntElement(self.offsetBits_x(), 16, 1)
    
    #
    # Set the value of the field 'x'
    #
    def set_x(self, value):
        self.setSIntElement(self.offsetBits_x(), 16, value, 1)
    
    #
    # Return the size, in bytes, of the field 'x'
    #
    def size_x(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'x'
    #
    def sizeBits_x(self):
        return 16
    
    #
    # Accessor methods for field: y
    #   Field type: short
    #   Offset (bits): 64
    #   Size (bits): 16
    #

    #
    # Return whether the field 'y' is signed (False).
    #
    def isSigned_y(self):
        return False
    
    #
    # Return whether the field 'y' is an array (False).
    #
    def isArray_y(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'y'
    #
    def offset_y(self):
        return (64 / 8)
    
    #
    # Return the offset (in bits) of the field 'y'
    #
    def offsetBits_y(self):
        return 64
    
    #
    # Return the value (as a short) of the field 'y'
    #
    def get_y(self):
        return self.getSIntElement(self.offsetBits_y(), 16, 1)
    
    #
    # Set the value of the field 'y'
    #
    def set_y(self, value):
        self.setSIntElement(self.offsetBits_y(), 16, value, 1)
    
    #
    # Return the size, in bytes, of the field 'y'
    #
    def size_y(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'y'
    #
    def sizeBits_y(self):
        return 16
