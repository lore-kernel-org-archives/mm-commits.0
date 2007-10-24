From: akpm@linux-foundation.org
Subject: + git-v9fs-fixup.patch added to -mm tree
Date: Wed, 24 Oct 2007 14:36:58 -0700
Message-ID: <200710242136.l9OLawrJ013677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42944 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752711AbXJXVhD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 17:37:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ericvh@gmail.com


The patch titled
     git-v9fs-fixup
has been added to the -mm tree.  Its filename is
     git-v9fs-fixup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-v9fs-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Fix git conflicts in git-v9fs.

Cc: Eric Van Hensbergen <ericvh@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/v9fs.c    |    3 ---
 net/9p/Kconfig  |    3 ---
 net/9p/Makefile |    7 +------
 3 files changed, 1 insertion(+), 12 deletions(-)

diff -puN fs/9p/v9fs.c~git-v9fs-fixup fs/9p/v9fs.c
--- a/fs/9p/v9fs.c~git-v9fs-fixup
+++ a/fs/9p/v9fs.c
@@ -162,10 +162,7 @@ static void v9fs_parse_options(struct v9
 				if (*e != '\0')
 					v9ses->uid = ~0;
 			}
-<<<<<<< HEAD:fs/9p/v9fs.c
 			kfree(s);
-=======
->>>>>>> FETCH_HEAD:fs/9p/v9fs.c
 			break;
 
 		default:
diff -puN net/9p/Kconfig~git-v9fs-fixup net/9p/Kconfig
--- a/net/9p/Kconfig~git-v9fs-fixup
+++ a/net/9p/Kconfig
@@ -23,7 +23,6 @@ config NET_9P_FD
 	  file descriptors.  TCP/IP is the default transport for 9p,
 	  so if you are going to use 9p, you'll likely want this.
 
-<<<<<<< HEAD:net/9p/Kconfig
 config NET_9P_VIRTIO
 	depends on NET_9P && EXPERIMENTAL && VIRTIO
 	tristate "9P Virtio Transport (Experimental)"
@@ -31,8 +30,6 @@ config NET_9P_VIRTIO
 	  This builds support for a transports between
 	  guest partitions and a host partition.
 
-=======
->>>>>>> FETCH_HEAD:net/9p/Kconfig
 config NET_9P_DEBUG
 	bool "Debug information"
 	depends on NET_9P
diff -puN net/9p/Makefile~git-v9fs-fixup net/9p/Makefile
--- a/net/9p/Makefile~git-v9fs-fixup
+++ a/net/9p/Makefile
@@ -1,9 +1,6 @@
 obj-$(CONFIG_NET_9P) := 9pnet.o
 obj-$(CONFIG_NET_9P_FD) += 9pnet_fd.o
-<<<<<<< HEAD:net/9p/Makefile
 obj-$(CONFIG_NET_9P_VIRTIO) += 9pnet_virtio.o
-=======
->>>>>>> FETCH_HEAD:net/9p/Makefile
 
 9pnet-objs := \
 	mod.o \
@@ -16,9 +13,7 @@ obj-$(CONFIG_NET_9P_VIRTIO) += 9pnet_vir
 
 9pnet_fd-objs := \
 	trans_fd.o \
-<<<<<<< HEAD:net/9p/Makefile
 
 9pnet_virtio-objs := \
 	trans_virtio.o \
-=======
->>>>>>> FETCH_HEAD:net/9p/Makefile
+
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-hwmon.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-arm-hack.patch
nf_ct_alloc_hashtable-use-__gfp_nowarn.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd-fixup.patch
fix-build-breakage-if-sysfs-fix.patch
git-unionfs.patch
git-v9fs-fixup.patch
git-watchdog.patch
watchdog-add-nano-7240-driver-checkpatch-fixes.patch
git-wireless.patch
git-wireless-fixup.patch
jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
git-x86.patch
git-x86-fixup.patch
oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
pie-executable-randomization.patch
pie-executable-randomization-checkpatch-fixes.patch
sync_sb_inodes-propagate-errors.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
