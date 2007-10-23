From: akpm@linux-foundation.org
Subject: + jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch added to -mm tree
Date: Tue, 23 Oct 2007 12:22:17 -0700
Message-ID: <200710231922.l9NJMHsk002478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40240 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753193AbXJWTXb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 15:23:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, IvDoorn@gmail.com, anton@samba.org, arjan@linux.intel.com, linville@tuxdriver.com


The patch titled
     jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: no space after that open parenthesis '('
#23: FILE: drivers/net/wireless/rt2x00/rt2x00lib.h:33:
+#define LINK_TUNE_INTERVAL	( round_jiffies_relative(HZ) )

ERROR: no space before that close parenthesis ')'
#23: FILE: drivers/net/wireless/rt2x00/rt2x00lib.h:33:
+#define LINK_TUNE_INTERVAL	( round_jiffies_relative(HZ) )

total: 2 errors, 0 warnings, 8 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/rt2x00/rt2x00lib.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/wireless/rt2x00/rt2x00lib.h~jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes drivers/net/wireless/rt2x00/rt2x00lib.h
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h~jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes
+++ a/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -30,8 +30,8 @@
  * Interval defines
  * Both the link tuner as the rfkill will be called once per second.
  */
-#define LINK_TUNE_INTERVAL	( round_jiffies_relative(HZ) )
-#define RFKILL_POLL_INTERVAL	( 1000 )
+#define LINK_TUNE_INTERVAL	(round_jiffies_relative(HZ))
+#define RFKILL_POLL_INTERVAL	(1000)
 
 /*
  * Radio control handlers.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-arm-hack.patch
nf_ct_alloc_hashtable-use-__gfp_nowarn.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd-fixup.patch
fix-build-breakage-if-sysfs-fix.patch
git-scsi-misc.patch
git-unionfs.patch
git-watchdog-fixup.patch
documentation-watchdog-src-watchdog-simplec-improve-this-code-checkpatch-fixes.patch
git-wireless.patch
git-wireless-fixup.patch
jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
git-x86.patch
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
