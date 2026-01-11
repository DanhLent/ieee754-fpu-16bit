"""
Generates test vectors (A, B, Op, Expected) for Adder/Subtractor verification.
Output: test_vectors.txt
"""

import numpy as np
import struct
import sys

# Configuration
OUTPUT_FILE = "test_vectors.txt"
NUM_RANDOM_CASES = 10000  # Number of random tests

def float16_to_hex(f):
    """Converts numpy float16 to 4-digit hex string."""
    val = np.float16(f).tobytes()
    return hex(struct.unpack('<H', val)[0])[2:].zfill(4)

def generate_corners():
    """Generates specific corner cases."""
    corners = [
        # Zero checks
        (0.0, 0.0), (0.0, -0.0), (-0.0, 0.0), (-0.0, -0.0),
        # Basic Integers
        (1.0, 1.0), (1.0, 2.0), (10.0, -10.0),
        # Subnormals (Smallest numbers)
        (6.104e-5, 6.104e-5), # Min subnormal
        # Normals (Smallest normalized)
        (6.104e-5, 1.0), 
        # Large numbers & Overflow
        (65504.0, 1.0),       # Max float16
        (65504.0, 65504.0),   # Overflow to Inf
        # Infinity checks
        (np.inf, 1.0), (1.0, np.inf), (np.inf, np.inf),
        (np.inf, -np.inf),    # NaN generation case
        # NaN inputs
        (np.nan, 1.0), (1.0, np.nan), (np.nan, np.nan)
    ]
    return corners

def write_vectors():
    print(f"[INFO] Generating test vectors to {OUTPUT_FILE}...")
    
    with open(OUTPUT_FILE, "w") as f:
        # 1. Generate Corner Cases
        corners = generate_corners()
        for a, b in corners:
            # Op: 0 (Add)
            res_add = np.float16(a) + np.float16(b)
            f.write(f"{float16_to_hex(a)} {float16_to_hex(b)} 0 {float16_to_hex(res_add)}\n")
            # Op: 1 (Sub)
            res_sub = np.float16(a) - np.float16(b)
            f.write(f"{float16_to_hex(a)} {float16_to_hex(b)} 1 {float16_to_hex(res_sub)}\n")

        # 2. Generate Random Cases
        for _ in range(NUM_RANDOM_CASES):
            # Generate random 16-bit integers and interpret as float16
            a_int = np.random.randint(0, 65536)
            b_int = np.random.randint(0, 65536)
            
            a_val = np.frombuffer(struct.pack('<H', a_int), dtype=np.float16)[0]
            b_val = np.frombuffer(struct.pack('<H', b_int), dtype=np.float16)[0]
            
            # Random Opcode
            opcode = np.random.randint(0, 2)
            
            if opcode == 0:
                res = a_val + b_val
            else:
                res = a_val - b_val
            
            f.write(f"{hex(a_int)[2:].zfill(4)} {hex(b_int)[2:].zfill(4)} {opcode} {float16_to_hex(res)}\n")

    print(f"[SUCCESS] Generated {len(corners)*2 + NUM_RANDOM_CASES} vectors.")

if __name__ == "__main__":
    write_vectors()
