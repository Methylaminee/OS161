# OS161
OS161 Repo for SDP Course @PoliTo

#### Project structure be like 

    /OS161
        /src
        /toolbuild
        /tools
        /root
        /scratch
 
#### Steps for configuration

    1. Create folder tree as above
    2. Download requisites in sh and unpack them on `/os161/scratch`
    3. Run install sh
    
#### Laboratories

##### Mandatory

- [x] OS161: Overall view of Environment, Kernel Tuning, Debugging
- [x] Memory: Virtual Memory; System Calls: Read, Write, Exit
- [x] Synchro: Locks, CVs, Spinlocks, WCs, Semaphores
- [x] System Calls: Waitpid
- [x] FS: sys calls Open, Close, Read, Write
    
##### Optional

- [ ] Full support for kfree()
- [ ] Change solution implemented for Memory lab
- [ ] Use of optimized bitmap for freeFrames (1bit = 1frame, now 8bit = 1 frame)
- [x] Stats for allocated/free memory with `memstats` command
- [ ] Optimize free location research and MUTEX requirements
- [ ] Arguments to main