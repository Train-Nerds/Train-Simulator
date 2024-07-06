from multiprocessing import Process
import os

COMPUTERS = 4
IMAGES = 1000
IMAGES_PER_COMPUTER = IMAGES // COMPUTERS

THREADS = 10 # Don't use green threads, use real cores (hyperthreading counts as real cores).
IMAGES_PER_THREAD = IMAGES_PER_COMPUTER // THREADS

COMPUTER = 2 # Start counting at 0, so we go [0, 1, 2, 3].

def work(t):
    print(f"Started work on {t}.")
    for i in range(IMAGES_PER_THREAD):
        seed = COMPUTER*IMAGES_PER_COMPUTER + IMAGES_PER_THREAD*t + i
        os.system(f"python3 terrainGeneration.py {seed}")
    print(f"Finished work on {t}.")

if __name__ == '__main__':
    processes = []
    print(f"Generating {IMAGES_PER_COMPUTER} images across {THREADS} threads.")
    for t in range(THREADS):
        p = Process(target=work, args=(t,))
        p.start()
        processes.append(p)
    for p in processes:
        p.join()
    print("Done.")