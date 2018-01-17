

Use a good server with lots of RAM. The more RAM you have, the bigger the file system, or the smaller the block size.

Namenode: The core metadata server of Hadoop. This is the most critical piece of the system, and there can only be one of these. This stores both the file system image and the file system journal. The namenode keeps all of the filesystem layout information (files, blocks, directories, permissions, etc) and the block locations. The filesystem layout is persisted on disk and the block locations are kept solely in memory. When a client opens a file, the namenode tells the client the locations of all the blocks in the file; the client then no longer needs to communicate with the namenode for data transfer.

Namenode: We recommend at least 8GB of RAM (minimum is 2GB RAM), preferably 16GB or more. A rough rule of thumb is 1GB per 100TB of raw disk space; the actual requirements is around 1GB per million objects (files, directories, and blocks). The CPU requirements are any modern multi-core server CPU. Typically, the namenode will only use 2-5% of your CPU. As this is a single point of failure, the most important requirement is reliable hardware rather than high performance hardware. We suggest a node with redundant power supplies and at least 2 hard drives.

https://twiki.opensciencegrid.org/bin/view/Documentation/HadoopUnderstanding:
https://stackoverflow.com/questions/13192835/hadoop-namenode-memory-usage
