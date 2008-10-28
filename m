From: akpm@linux-foundation.org
Subject: - ext3-add-support-for-non-native-signed-unsigned-htree-hash-algorithms-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 28 Oct 2008 14:43:19 -0700
Message-ID: <200810282143.m9SLhJ7g012615@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753684AbYJ1Vnv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 17:43:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, phillips@phunq.net, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     ext3-add-support-for-non-native-signed-unsigned-htree-hash-algorithms-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ext3-add-support-for-non-native-signed-unsigned-htree-hash-algorithms-checkpatch-fixes.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3-add-support-for-non-native-signed-unsigned-htree-hash-algorithms-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: space prohibited between function name and open parenthesis '('
#29: FILE: fs/ext3/hash.c:38:
+static __u32 dx_hack_hash (const char *name, int len, int unsigned_flag)

ERROR: code indent should use tabs where possible
#33: FILE: fs/ext3/hash.c:41:
+ ^Iconst unsigned char *ucp = (const unsigned char *) name;$

total: 1 errors, 1 warnings, 189 lines checked

./patches/ext3-add-support-for-non-native-signed-unsigned-htree-hash-algorithms.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Daniel Phillips <phillips@phunq.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/hash.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ext3/hash.c~ext3-add-support-for-non-native-signed-unsigned-htree-hash-algorithms-checkpatch-fixes fs/ext3/hash.c
--- a/fs/ext3/hash.c~ext3-add-support-for-non-native-signed-unsigned-htree-hash-algorithms-checkpatch-fixes
+++ a/fs/ext3/hash.c
@@ -35,10 +35,10 @@ static void TEA_transform(__u32 buf[4], 
 
 
 /* The old legacy hash */
-static __u32 dx_hack_hash (const char *name, int len, int unsigned_flag)
+static __u32 dx_hack_hash(const char *name, int len, int unsigned_flag)
 {
 	__u32 hash, hash0 = 0x12a3fe2d, hash1 = 0x37abe8f9;
- 	const unsigned char *ucp = (const unsigned char *) name;
+	const unsigned char *ucp = (const unsigned char *) name;
 	const signed char *scp = (const signed char *) name;
 	int c;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix.patch
fs-remove-prepare_write-commit_write-fix.patch
mm-write_cache_pages-writepage-error-fix.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace-checkpatch-fixes.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
pci-uninline-pci_ioremap_bar.patch
autofs4-collect-version-check-return-checkpatch-fixes.patch
maintainers-make-ioat-easier-to-find.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
fs-truncate-blocks-outside-i_size-after-generic_file_direct_write-error-fix.patch
init-properly-placing-noinline-keyword.patch
spi_gpio-driver-cleanups.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch
rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock-fix.patch
ext3-add-support-for-non-native-signed-unsigned-htree-hash-algorithms-checkpatch-fixes.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-broke.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

