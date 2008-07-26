From: akpm@linux-foundation.org
Subject: - documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:16:09 -0700
Message-ID: <200807262116.m6QLG9pr019806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757711AbYGZVRI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:17:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kernel1@cyberdogtech.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Documentation cleanup: trivial misspelling, punctuation, and grammar corrections.
has been removed from the -mm tree.  Its filename was
     documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation cleanup: trivial misspelling, punctuation, and grammar corrections.
From: Matt LaPlante <kernel1@cyberdogtech.com>

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/Intel-IOMMU.txt                     |    4 +--
 Documentation/accounting/taskstats-struct.txt     |    2 -
 Documentation/cpu-freq/governors.txt              |    2 -
 Documentation/edac.txt                            |    2 -
 Documentation/filesystems/proc.txt                |    4 +--
 Documentation/filesystems/vfs.txt                 |    6 ++--
 Documentation/ia64/kvm.txt                        |    8 +++---
 Documentation/input/cs461x.txt                    |    2 -
 Documentation/ioctl/ioctl-decoding.txt            |    4 +--
 Documentation/iostats.txt                         |    2 -
 Documentation/keys.txt                            |    2 -
 Documentation/leds-class.txt                      |    2 -
 Documentation/local_ops.txt                       |    2 -
 Documentation/networking/bonding.txt              |    2 -
 Documentation/networking/can.txt                  |    4 +--
 Documentation/networking/packet_mmap.txt          |    2 -
 Documentation/networking/tc-actions-env-rules.txt |   15 ++++++------
 Documentation/powerpc/booting-without-of.txt      |    8 +++---
 Documentation/powerpc/qe_firmware.txt             |    2 -
 Documentation/s390/driver-model.txt               |    2 -
 Documentation/scsi/ibmmca.txt                     |    6 ++--
 Documentation/scsi/lpfc.txt                       |    2 -
 Documentation/scsi/scsi_fc_transport.txt          |    6 ++--
 Documentation/sh/clk.txt                          |    2 -
 Documentation/sound/alsa/Audiophile-Usb.txt       |   10 ++++----
 Documentation/sound/alsa/hda_codec.txt            |    2 -
 Documentation/sound/alsa/soc/dapm.txt             |    2 -
 Documentation/sysctl/vm.txt                       |    2 -
 Documentation/timers/highres.txt                  |    2 -
 Documentation/usb/authorization.txt               |    2 -
 Documentation/video4linux/sn9c102.txt             |    2 -
 Documentation/vm/hugetlbpage.txt                  |    2 -
 Documentation/vm/numa_memory_policy.txt           |    4 +--
 Documentation/volatile-considered-harmful.txt     |    2 -
 drivers/message/fusion/lsi/mpi_history.txt        |    6 ++--
 35 files changed, 65 insertions(+), 64 deletions(-)

diff -puN Documentation/Intel-IOMMU.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/Intel-IOMMU.txt
--- a/Documentation/Intel-IOMMU.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/Intel-IOMMU.txt
@@ -48,7 +48,7 @@ IOVA generation is pretty generic. We us
 but these are not global address spaces, but separate for each domain.
 Different DMA engines may support different number of domains.
 
-We also allocate gaurd pages with each mapping, so we can attempt to catch
+We also allocate guard pages with each mapping, so we can attempt to catch
 any overflow that might happen.
 
 
@@ -112,4 +112,4 @@ TBD
 
 - For compatibility testing, could use unity map domain for all devices, just
   provide a 1-1 for all useful memory under a single domain for all devices.
-- API for paravirt ops for abstracting functionlity for VMM folks.
+- API for paravirt ops for abstracting functionality for VMM folks.
diff -puN Documentation/accounting/taskstats-struct.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/accounting/taskstats-struct.txt
--- a/Documentation/accounting/taskstats-struct.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/accounting/taskstats-struct.txt
@@ -6,7 +6,7 @@ This document contains an explanation of
 There are three different groups of fields in the struct taskstats:
 
 1) Common and basic accounting fields
-    If CONFIG_TASKSTATS is set, the taskstats inteface is enabled and
+    If CONFIG_TASKSTATS is set, the taskstats interface is enabled and
     the common fields and basic accounting fields are collected for
     delivery at do_exit() of a task.
 2) Delay accounting fields
diff -puN Documentation/cpu-freq/governors.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/cpu-freq/governors.txt
--- a/Documentation/cpu-freq/governors.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/cpu-freq/governors.txt
@@ -122,7 +122,7 @@ around '10000' or more.
 show_sampling_rate_(min|max): the minimum and maximum sampling rates
 available that you may set 'sampling_rate' to.
 
-up_threshold: defines what the average CPU usaged between the samplings
+up_threshold: defines what the average CPU usage between the samplings
 of 'sampling_rate' needs to be for the kernel to make a decision on
 whether it should increase the frequency.  For example when it is set
 to its default value of '80' it means that between the checking
diff -puN Documentation/edac.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/edac.txt
--- a/Documentation/edac.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/edac.txt
@@ -327,7 +327,7 @@ Sdram memory scrubbing rate:
 	'sdram_scrub_rate'
 
 	Read/Write attribute file that controls memory scrubbing. The scrubbing
-	rate is set by writing a minimum bandwith in bytes/sec to the attribute
+	rate is set by writing a minimum bandwidth in bytes/sec to the attribute
 	file. The rate will be translated to an internal value that gives at
 	least the specified rate.
 
diff -puN Documentation/filesystems/proc.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/filesystems/proc.txt
@@ -931,7 +931,7 @@ group_prealloc  max_to_scan  mb_groups  
 stats  stream_req
 
 mb_groups:
-This file gives the details of mutiblock allocator buddy cache of free blocks
+This file gives the details of multiblock allocator buddy cache of free blocks
 
 mb_history:
 Multiblock allocation history.
@@ -1474,7 +1474,7 @@ used because pages_free(1355) is smaller
 normal page requirement. If requirement is DMA zone(index=0), protection[0]
 (=0) is used.
 
-zone[i]'s protection[j] is calculated by following exprssion.
+zone[i]'s protection[j] is calculated by following expression.
 
 (i < j):
   zone[i]->protection[j]
diff -puN Documentation/filesystems/vfs.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/filesystems/vfs.txt
@@ -143,7 +143,7 @@ struct file_system_type {
 
 The get_sb() method has the following arguments:
 
-  struct file_system_type *fs_type: decribes the filesystem, partly initialized
+  struct file_system_type *fs_type: describes the filesystem, partly initialized
   	by the specific filesystem code
 
   int flags: mount flags
@@ -895,9 +895,9 @@ struct dentry_operations {
 	iput() yourself
 
   d_dname: called when the pathname of a dentry should be generated.
-	Usefull for some pseudo filesystems (sockfs, pipefs, ...) to delay
+	Useful for some pseudo filesystems (sockfs, pipefs, ...) to delay
 	pathname generation. (Instead of doing it when dentry is created,
-	its done only when the path is needed.). Real filesystems probably
+	it's done only when the path is needed.). Real filesystems probably
 	dont want to use it, because their dentries are present in global
 	dcache hash, so their hash should be an invariant. As no lock is
 	held, d_dname() should not try to modify the dentry itself, unless
diff -puN Documentation/ia64/kvm.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/ia64/kvm.txt
--- a/Documentation/ia64/kvm.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/ia64/kvm.txt
@@ -50,9 +50,9 @@ Note: For step 2, please make sure that 
 		/usr/local/bin/qemu-system-ia64 -smp xx -m 512 -hda $your_image
 		(xx is the number of virtual processors for the guest, now the maximum value is 4)
 
-5. Known possibile issue on some platforms with old Firmware.
+5. Known possible issue on some platforms with old Firmware.
 
-If meet strange host crashe issues, try to solve it through either of the following ways:
+In the event of strange host crash issues, try to solve it through either of the following ways:
 
 (1): Upgrade your Firmware to the latest one.
 
@@ -65,8 +65,8 @@ index 0b53344..f02b0f7 100644
 	mov ar.pfs = loc1
 	mov rp = loc0
 	;;
--	srlz.d				// seralize restoration of psr.l
-+	srlz.i			// seralize restoration of psr.l
+-	srlz.d				// serialize restoration of psr.l
++	srlz.i			// serialize restoration of psr.l
 +	;;
 	br.ret.sptk.many b0
  END(ia64_pal_call_static)
diff -puN Documentation/input/cs461x.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/input/cs461x.txt
--- a/Documentation/input/cs461x.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/input/cs461x.txt
@@ -31,7 +31,7 @@ The driver works with ALSA drivers simul
 uses joystick as input device and PCM device as sound output in one time.
 There are no sound or input collisions detected. The source code have
 comments about them; but I've found the joystick can be initialized 
-separately of ALSA modules. So, you canm use only one joystick driver
+separately of ALSA modules. So, you can use only one joystick driver
 without ALSA drivers. The ALSA drivers are not needed to compile or
 run this driver.
 
diff -puN Documentation/ioctl/ioctl-decoding.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/ioctl/ioctl-decoding.txt
--- a/Documentation/ioctl/ioctl-decoding.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/ioctl/ioctl-decoding.txt
@@ -1,6 +1,6 @@
 To decode a hex IOCTL code:
 
-Most architecures use this generic format, but check
+Most architectures use this generic format, but check
 include/ARCH/ioctl.h for specifics, e.g. powerpc
 uses 3 bits to encode read/write and 13 bits for size.
 
@@ -18,7 +18,7 @@ uses 3 bits to encode read/write and 13 
  7-0	function #
 
 
- So for example 0x82187201 is a read with arg length of 0x218,
+So for example 0x82187201 is a read with arg length of 0x218,
 character 'r' function 1. Grepping the source reveals this is:
 
 #define VFAT_IOCTL_READDIR_BOTH         _IOR('r', 1, struct dirent [2])
diff -puN Documentation/iostats.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/iostats.txt
--- a/Documentation/iostats.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/iostats.txt
@@ -143,7 +143,7 @@ disk and partition statistics are consis
 keep record of the partition-relative address, an operation is attributed to
 the partition which contains the first sector of the request after the
 eventual merges. As requests can be merged across partition, this could lead
-to some (probably insignificant) innacuracy.
+to some (probably insignificant) inaccuracy.
 
 Additional notes
 ----------------
diff -puN Documentation/keys.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/keys.txt
--- a/Documentation/keys.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/keys.txt
@@ -864,7 +864,7 @@ payload contents" for more information.
     request_key_with_auxdata() respectively.
 
     These two functions return with the key potentially still under
-    construction.  To wait for contruction completion, the following should be
+    construction.  To wait for construction completion, the following should be
     called:
 
 	int wait_for_key_construction(struct key *key, bool intr);
diff -puN Documentation/leds-class.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/leds-class.txt
--- a/Documentation/leds-class.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/leds-class.txt
@@ -59,7 +59,7 @@ Hardware accelerated blink of LEDs
 
 Some LEDs can be programmed to blink without any CPU interaction. To
 support this feature, a LED driver can optionally implement the
-blink_set() function (see <linux/leds.h>). If implemeted, triggers can
+blink_set() function (see <linux/leds.h>). If implemented, triggers can
 attempt to use it before falling back to software timers. The blink_set()
 function should return 0 if the blink setting is supported, or -EINVAL
 otherwise, which means that LED blinking will be handled by software.
diff -puN Documentation/local_ops.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/local_ops.txt
--- a/Documentation/local_ops.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/local_ops.txt
@@ -36,7 +36,7 @@ It can be done by slightly modifying the
 their UP variant must be kept. It typically means removing LOCK prefix (on
 i386 and x86_64) and any SMP sychronization barrier. If the architecture does
 not have a different behavior between SMP and UP, including asm-generic/local.h
-in your archtecture's local.h is sufficient.
+in your architecture's local.h is sufficient.
 
 The local_t type is defined as an opaque signed long by embedding an
 atomic_long_t inside a structure. This is made so a cast from this type to a
diff -puN Documentation/networking/bonding.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/networking/bonding.txt
--- a/Documentation/networking/bonding.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/networking/bonding.txt
@@ -631,7 +631,7 @@ xmit_hash_policy
 		in environments where a layer3 gateway device is
 		required to reach most destinations.
 
-		This algorithm is 802.3ad complient.
+		This algorithm is 802.3ad compliant.
 
 	layer3+4
 
diff -puN Documentation/networking/can.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/networking/can.txt
--- a/Documentation/networking/can.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/networking/can.txt
@@ -186,7 +186,7 @@ solution for a couple of reasons:
 
   The Linux network devices (by default) just can handle the
   transmission and reception of media dependent frames. Due to the
-  arbritration on the CAN bus the transmission of a low prio CAN-ID
+  arbitration on the CAN bus the transmission of a low prio CAN-ID
   may be delayed by the reception of a high prio CAN frame. To
   reflect the correct* traffic on the node the loopback of the sent
   data has to be performed right after a successful transmission. If
@@ -481,7 +481,7 @@ solution for a couple of reasons:
   - stats_timer: To calculate the Socket CAN core statistics
     (e.g. current/maximum frames per second) this 1 second timer is
     invoked at can.ko module start time by default. This timer can be
-    disabled by using stattimer=0 on the module comandline.
+    disabled by using stattimer=0 on the module commandline.
 
   - debug: (removed since SocketCAN SVN r546)
 
diff -puN Documentation/networking/packet_mmap.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/networking/packet_mmap.txt
--- a/Documentation/networking/packet_mmap.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/networking/packet_mmap.txt
@@ -326,7 +326,7 @@ just one call to mmap is needed:
     mmap(0, size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
 
 If tp_frame_size is a divisor of tp_block_size frames will be 
-contiguosly spaced by tp_frame_size bytes. If not, each 
+contiguously spaced by tp_frame_size bytes. If not, each
 tp_block_size/tp_frame_size frames there will be a gap between 
 the frames. This is because a frame cannot be spawn across two
 blocks. 
diff -puN Documentation/networking/tc-actions-env-rules.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/networking/tc-actions-env-rules.txt
--- a/Documentation/networking/tc-actions-env-rules.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/networking/tc-actions-env-rules.txt
@@ -4,26 +4,27 @@ The "enviromental" rules for authors of 
 1) If you stealeth or borroweth any packet thou shalt be branching
 from the righteous path and thou shalt cloneth.
 
-For example if your action queues a packet to be processed later
-or intentionaly branches by redirecting a packet then you need to
+For example if your action queues a packet to be processed later,
+or intentionally branches by redirecting a packet, then you need to
 clone the packet.
+
 There are certain fields in the skb tc_verd that need to be reset so we
-avoid loops etc. A few are generic enough so much so that skb_act_clone()
-resets them for you. So invoke skb_act_clone() rather than skb_clone()
+avoid loops, etc.  A few are generic enough that skb_act_clone()
+resets them for you, so invoke skb_act_clone() rather than skb_clone().
 
 2) If you munge any packet thou shalt call pskb_expand_head in the case
 someone else is referencing the skb. After that you "own" the skb.
 You must also tell us if it is ok to munge the packet (TC_OK2MUNGE),
 this way any action downstream can stomp on the packet.
 
-3) dropping packets you dont own is a nono. You simply return
+3) Dropping packets you don't own is a no-no. You simply return
 TC_ACT_SHOT to the caller and they will drop it.
 
 The "enviromental" rules for callers of actions (qdiscs etc) are:
 
-*) thou art responsible for freeing anything returned as being
+*) Thou art responsible for freeing anything returned as being
 TC_ACT_SHOT/STOLEN/QUEUED. If none of TC_ACT_SHOT/STOLEN/QUEUED is
-returned then all is great and you dont need to do anything.
+returned, then all is great and you don't need to do anything.
 
 Post on netdev if something is unclear.
 
diff -puN Documentation/powerpc/booting-without-of.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/powerpc/booting-without-of.txt
--- a/Documentation/powerpc/booting-without-of.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/powerpc/booting-without-of.txt
@@ -708,7 +708,7 @@ device or bus to be described by the dev
 In general, the format of an address for a device is defined by the
 parent bus type, based on the #address-cells and #size-cells
 properties.  Note that the parent's parent definitions of #address-cells
-and #size-cells are not inhereted so every node with children must specify
+and #size-cells are not inherited so every node with children must specify
 them.  The kernel requires the root node to have those properties defining
 addresses format for devices directly mapped on the processor bus.
 
@@ -1777,7 +1777,7 @@ platforms are moved over to use the flat
 
       Xilinx uartlite devices are simple fixed speed serial ports.
 
-      Requred properties:
+      Required properties:
        - current-speed : Baud rate of uartlite
 
       v) Xilinx hwicap
@@ -1799,7 +1799,7 @@ platforms are moved over to use the flat
       Xilinx UART 16550 devices are very similar to the NS16550 but with
       different register spacing and an offset from the base address.
 
-      Requred properties:
+      Required properties:
        - clock-frequency : Frequency of the clock input
        - reg-offset : A value of 3 is required
        - reg-shift : A value of 2 is required
@@ -1953,7 +1953,7 @@ prefixed with the string "marvell,", for
 1) The /system-controller node
 
   This node is used to represent the system-controller and must be
-  present when the system uses a system contller chip. The top-level
+  present when the system uses a system controller chip. The top-level
   system-controller node contains information that is global to all
   devices within the system controller chip. The node name begins
   with "system-controller" followed by the unit address, which is
diff -puN Documentation/powerpc/qe_firmware.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/powerpc/qe_firmware.txt
--- a/Documentation/powerpc/qe_firmware.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/powerpc/qe_firmware.txt
@@ -217,7 +217,7 @@ Although it is not recommended, you can 
 field to skip matching SOCs altogether.
 
 The 'model' field is a 16-bit number that matches the actual SOC. The
-'major' and 'minor' fields are the major and minor revision numbrs,
+'major' and 'minor' fields are the major and minor revision numbers,
 respectively, of the SOC.
 
 For example, to match the 8323, revision 1.0:
diff -puN Documentation/s390/driver-model.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/s390/driver-model.txt
--- a/Documentation/s390/driver-model.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/s390/driver-model.txt
@@ -25,7 +25,7 @@ device 4711 via subchannel 1 in subchann
 subchannel. Device 1234 is accessed via subchannel 0 in subchannel set 1.
 
 The subchannel named 'defunct' does not represent any real subchannel on the
-system; it is a pseudo subchannel where disconnnected ccw devices are moved to
+system; it is a pseudo subchannel where disconnected ccw devices are moved to
 if they are displaced by another ccw device becoming operational on their
 former subchannel. The ccw devices will be moved again to a proper subchannel
 if they become operational again on that subchannel.
diff -puN Documentation/scsi/ibmmca.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/scsi/ibmmca.txt
--- a/Documentation/scsi/ibmmca.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/scsi/ibmmca.txt
@@ -524,7 +524,7 @@
    - Michael Lang
  
    June 25 1997: (v1.8b)
-   1) Some cosmetical changes for the handling of SCSI-device-types.
+   1) Some cosmetic changes for the handling of SCSI-device-types.
       Now, also CD-Burners / WORMs and SCSI-scanners should work. For
       MO-drives I have no experience, therefore not yet supported.
       In logical_devices I changed from different type-variables to one
@@ -914,7 +914,7 @@
       in version 4.0. This was never really necessary, as all troubles were
       based on non-command related reasons up to now, so bypassing commands
       did not help to avoid any bugs. It is kept in 3.2X for debugging reasons.
-   5) Dynamical reassignment of ldns was again verified and analyzed to be
+   5) Dynamic reassignment of ldns was again verified and analyzed to be
       completely inoperational. This is corrected and should work now.
    6) All commands that get sent to the SCSI adapter were verified and
       completed in such a way, that they are now completely conform to the
@@ -1386,7 +1386,7 @@
    concerning the Linux-kernel in special, this SCSI-driver comes without any
    warranty. Its functionality is tested as good as possible on certain 
    machines and combinations of computer hardware, which does not exclude,
-   that dataloss or severe damage of hardware is possible while using this
+   that data loss or severe damage of hardware is possible while using this
    part of software on some arbitrary computer hardware or in combination 
    with other software packages. It is highly recommended to make backup
    copies of your data before using this software. Furthermore, personal
diff -puN Documentation/scsi/lpfc.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/scsi/lpfc.txt
--- a/Documentation/scsi/lpfc.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/scsi/lpfc.txt
@@ -36,7 +36,7 @@ Cable pull and temporary device Loss:
   being removed, a switch rebooting, or a device reboot), the driver could
   hide the disappearance of the device from the midlayer. I/O's issued to
   the LLDD would simply be queued for a short duration, allowing the device
-  to reappear or link come back alive, with no inadvertant side effects
+  to reappear or link come back alive, with no inadvertent side effects
   to the system. If the driver did not hide these conditions, i/o would be
   errored by the driver, the mid-layer would exhaust its retries, and the
   device would be taken offline. Manual intervention would be required to
diff -puN Documentation/scsi/scsi_fc_transport.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/scsi/scsi_fc_transport.txt
--- a/Documentation/scsi/scsi_fc_transport.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/scsi/scsi_fc_transport.txt
@@ -65,7 +65,7 @@ Overview:
     discussion will concentrate on NPIV.
 
   Note: World Wide Name assignment (and uniqueness guarantees) are left
-    up to an administrative entity controling the vport. For example,
+    up to an administrative entity controlling the vport. For example,
     if vports are to be associated with virtual machines, a XEN mgmt
     utility would be responsible for creating wwpn/wwnn's for the vport,
     using it's own naming authority and OUI. (Note: it already does this
@@ -91,7 +91,7 @@ Device Trees and Vport Objects:
   Here's what to expect in the device tree :
    The typical Physical Port's Scsi_Host:
      /sys/devices/.../host17/
-   and it has the typical decendent tree:
+   and it has the typical descendant tree:
      /sys/devices/.../host17/rport-17:0-0/target17:0:0/17:0:0:0:
    and then the vport is created on the Physical Port:
      /sys/devices/.../host17/vport-17:0-0
@@ -192,7 +192,7 @@ Vport States:
       independent of the adapter's link state.
     - Instantiation of the vport on the FC link via ELS traffic, etc.
       This is equivalent to a "link up" and successfull link initialization.
-  Futher information can be found in the interfaces section below for
+  Further information can be found in the interfaces section below for
   Vport Creation.
 
   Once a vport has been instantiated with the kernel/LLDD, a vport state
diff -puN Documentation/sh/clk.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/sh/clk.txt
--- a/Documentation/sh/clk.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/sh/clk.txt
@@ -12,7 +12,7 @@ means no changes to adjanced clock
 Internally, the clk_set_rate_ex forwards request to clk->ops->set_rate method,
 if it is present in ops structure. The method should set the clock rate and adjust
 all needed clocks according to the passed algo_id.
-Exact values for algo_id are machine-dependend. For the sh7722, the following
+Exact values for algo_id are machine-dependent. For the sh7722, the following
 values are defined:
 
 	NO_CHANGE	= 0,
diff -puN Documentation/sound/alsa/Audiophile-Usb.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/sound/alsa/Audiophile-Usb.txt
--- a/Documentation/sound/alsa/Audiophile-Usb.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/sound/alsa/Audiophile-Usb.txt
@@ -236,15 +236,15 @@ The parameter can be given:
        alias snd-card-1 snd-usb-audio
        options snd-usb-audio index=1 device_setup=0x09
 
-CAUTION when initializaing the device
+CAUTION when initializing the device
 -------------------------------------
 
  * Correct initialization on the device requires that device_setup is given to
    the module BEFORE the device is turned on. So, if you use the "manual probing"
    method described above, take care to power-on the device AFTER this initialization.
 
- * Failing to respect this will lead in a misconfiguration of the device. In this case
-   turn off the device, unproble the snd-usb-audio module, then probe it again with 
+ * Failing to respect this will lead to a misconfiguration of the device. In this case
+   turn off the device, unprobe the snd-usb-audio module, then probe it again with
    correct device_setup parameter and then (and only then) turn on the device again.
 
  * If you've correctly initialized the device in a valid mode and then want to switch
@@ -388,9 +388,9 @@ There are 2 main potential issues when u
 
 Jack supports big endian devices only in recent versions (thanks to
 Andreas Steinmetz for his first big-endian patch). I can't remember 
-extacly when this support was released into jackd, let's just say that 
+exactly when this support was released into jackd, let's just say that
 with jackd version 0.103.0 it's almost ok (just a small bug is affecting 
-16bits Big-Endian devices, but since you've read  carefully the above 
+16bits Big-Endian devices, but since you've read carefully the above
 paragraphs, you're now using kernel >= 2.6.23 and your 16bits devices 
 are now Little Endians ;-) ).
 
diff -puN Documentation/sound/alsa/hda_codec.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/sound/alsa/hda_codec.txt
--- a/Documentation/sound/alsa/hda_codec.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/sound/alsa/hda_codec.txt
@@ -67,7 +67,7 @@ CONFIG_SND_HDA_POWER_SAVE kconfig.  It's
 to power up or may power down.  The controller should check the all
 belonging codecs on the bus whether they are actually powered off
 (check codec->power_on), and optionally the driver may power down the
-contoller side, too.
+controller side, too.
 
 The bus instance is created via snd_hda_bus_new().  You need to pass
 the card instance, the template, and the pointer to store the
diff -puN Documentation/sound/alsa/soc/dapm.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/sound/alsa/soc/dapm.txt
--- a/Documentation/sound/alsa/soc/dapm.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/sound/alsa/soc/dapm.txt
@@ -68,7 +68,7 @@ Audio DAPM widgets fall into a number of
 (Widgets are defined in include/sound/soc-dapm.h)
 
 Widgets are usually added in the codec driver and the machine driver. There are
-convience macros defined in soc-dapm.h that can be used to quickly build a
+convenience macros defined in soc-dapm.h that can be used to quickly build a
 list of widgets of the codecs and machines DAPM widgets.
 
 Most widgets have a name, register, shift and invert. Some widgets have extra
diff -puN Documentation/sysctl/vm.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/sysctl/vm.txt
@@ -116,7 +116,7 @@ of kilobytes free.  The VM uses this num
 value for each lowmem zone in the system.  Each lowmem zone gets 
 a number of reserved free pages based proportionally on its size.
 
-Some minimal ammount of memory is needed to satisfy PF_MEMALLOC
+Some minimal amount of memory is needed to satisfy PF_MEMALLOC
 allocations; if you set this to lower than 1024KB, your system will
 become subtly broken, and prone to deadlock under high loads.
 
diff -puN Documentation/timers/highres.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/timers/highres.txt
--- a/Documentation/timers/highres.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/timers/highres.txt
@@ -125,7 +125,7 @@ increase of flexibility and the avoidanc
 architectures justifies the slight increase of the binary size.
 
 The conversion of an architecture has no functional impact, but allows to
-utilize the high resolution and dynamic tick functionalites without any change
+utilize the high resolution and dynamic tick functionalities without any change
 to the clock event device and timer interrupt code. After the conversion the
 enabling of high resolution timers and dynamic ticks is simply provided by
 adding the kernel/time/Kconfig file to the architecture specific Kconfig and
diff -puN Documentation/usb/authorization.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/usb/authorization.txt
--- a/Documentation/usb/authorization.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/usb/authorization.txt
@@ -8,7 +8,7 @@ not) in a system. This feature will allo
 of USB devices, fully controlled by user space.
 
 As of now, when a USB device is connected it is configured and
-it's interfaces inmediately made available to the users. With this
+its interfaces are immediately made available to the users.  With this
 modification, only if root authorizes the device to be configured will
 then it be possible to use it.
 
diff -puN Documentation/video4linux/sn9c102.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/video4linux/sn9c102.txt
--- a/Documentation/video4linux/sn9c102.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/video4linux/sn9c102.txt
@@ -157,7 +157,7 @@ Loading can be done as shown below:
 
 	[root@localhost home]# modprobe sn9c102
 
-Note that the module is called "sn9c102" for historic reasons, althought it
+Note that the module is called "sn9c102" for historic reasons, although it
 does not just support the SN9C102.
 
 At this point all the devices supported by the driver and connected to the USB
diff -puN Documentation/vm/hugetlbpage.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/vm/hugetlbpage.txt
--- a/Documentation/vm/hugetlbpage.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/vm/hugetlbpage.txt
@@ -77,7 +77,7 @@ memory that is preset in system at this 
 to put this command in one of the local rc init files.  This will enable the
 kernel to request huge pages early in the boot process (when the possibility
 of getting physical contiguous pages is still very high). In either
-case, adminstrators will want to verify the number of hugepages actually
+case, administrators will want to verify the number of hugepages actually
 allocated by checking the sysctl or meminfo.
 
 /proc/sys/vm/nr_overcommit_hugepages indicates how large the pool of
diff -puN Documentation/vm/numa_memory_policy.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/vm/numa_memory_policy.txt
--- a/Documentation/vm/numa_memory_policy.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/vm/numa_memory_policy.txt
@@ -58,7 +58,7 @@ most general to most specific:
 	the policy at the time they were allocated.
 
     VMA Policy:  A "VMA" or "Virtual Memory Area" refers to a range of a task's
-    virtual adddress space.  A task may define a specific policy for a range
+    virtual address space.  A task may define a specific policy for a range
     of its virtual address space.   See the MEMORY POLICIES APIS section,
     below, for an overview of the mbind() system call used to set a VMA
     policy.
@@ -353,7 +353,7 @@ follows:
 
    Because of this extra reference counting, and because we must lookup
    shared policies in a tree structure under spinlock, shared policies are
-   more expensive to use in the page allocation path.  This is expecially
+   more expensive to use in the page allocation path.  This is especially
    true for shared policies on shared memory regions shared by tasks running
    on different NUMA nodes.  This extra overhead can be avoided by always
    falling back to task or system default policy for shared memory regions,
diff -puN Documentation/volatile-considered-harmful.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections Documentation/volatile-considered-harmful.txt
--- a/Documentation/volatile-considered-harmful.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/Documentation/volatile-considered-harmful.txt
@@ -114,6 +114,6 @@ CREDITS
 
 Original impetus and research by Randy Dunlap
 Written by Jonathan Corbet
-Improvements via coments from Satyam Sharma, Johannes Stezenbach, Jesper
+Improvements via comments from Satyam Sharma, Johannes Stezenbach, Jesper
 	Juhl, Heikki Orsila, H. Peter Anvin, Philipp Hahn, and Stefan
 	Richter.
diff -puN drivers/message/fusion/lsi/mpi_history.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections drivers/message/fusion/lsi/mpi_history.txt
--- a/drivers/message/fusion/lsi/mpi_history.txt~documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections
+++ a/drivers/message/fusion/lsi/mpi_history.txt
@@ -127,7 +127,7 @@ mpi_ioc.h
  *  08-08-01  01.02.01  Original release for v1.2 work.
  *                      New format for FWVersion and ProductId in
  *                      MSG_IOC_FACTS_REPLY and MPI_FW_HEADER.
- *  08-31-01  01.02.02  Addded event MPI_EVENT_SCSI_DEVICE_STATUS_CHANGE and
+ *  08-31-01  01.02.02  Added event MPI_EVENT_SCSI_DEVICE_STATUS_CHANGE and
  *                      related structure and defines.
  *                      Added event MPI_EVENT_ON_BUS_TIMER_EXPIRED.
  *                      Added MPI_IOCINIT_FLAGS_DISCARD_FW_IMAGE.
@@ -187,7 +187,7 @@ mpi_ioc.h
  *  10-11-06  01.05.12  Added MPI_IOCFACTS_EXCEPT_METADATA_UNSUPPORTED.
  *                      Added MaxInitiators field to PortFacts reply.
  *                      Added SAS Device Status Change ReasonCode for
- *                      asynchronous notificaiton.
+ *                      asynchronous notification.
  *                      Added MPI_EVENT_SAS_EXPANDER_STATUS_CHANGE and event
  *                      data structure.
  *                      Added new ImageType values for FWDownload and FWUpload
@@ -213,7 +213,7 @@ mpi_cnfg.h
  *                      Added _RESPONSE_ID_MASK definition to SCSI_PORT_1
  *                      page and updated the page version.
  *                      Added Information field and _INFO_PARAMS_NEGOTIATED
- *                      definitionto SCSI_DEVICE_0 page.
+ *                      definition to SCSI_DEVICE_0 page.
  *  06-22-00  01.00.03  Removed batch controls from LAN_0 page and updated the
  *                      page version.
  *                      Added BucketsRemaining to LAN_1 page, redefined the
_

Patches currently in -mm which might be from kernel1@cyberdogtech.com are

origin.patch

