From: akpm@linux-foundation.org
Subject: + oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes.patch added to -mm tree
Date: Tue, 23 Oct 2007 12:29:23 -0700
Message-ID: <200710231929.l9NJTNQQ002786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44558 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752062AbXJWT35 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 15:29:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, barry.kasindorf@amd.com, mingo@elte.hu, robert.richter@amd.com, tglx@linutronix.de


The patch titled
     oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: no space after that open parenthesis '('
#37: FILE: arch/x86/oprofile/op_model_athlon.c:35:
+#define CTRL_CLEAR_HI(x) ( x &= 0xfffffcf0 )

ERROR: no space before that close parenthesis ')'
#37: FILE: arch/x86/oprofile/op_model_athlon.c:35:
+#define CTRL_CLEAR_HI(x) ( x &= 0xfffffcf0 )

ERROR: need space after that ',' (ctx:VxV)
#44: FILE: arch/x86/oprofile/op_model_athlon.c:41:
+#define CTRL_SET_EVENT_HIGH(val,e) (val |= ((e >> 8) & 0xf))
                                ^

total: 3 errors, 0 warnings, 53 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Barry Kasindorf" <barry.kasindorf@amd.com>
Cc: Barry Kasindorf <barry.kasindorf@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/oprofile/op_model_athlon.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/oprofile/op_model_athlon.c~oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes arch/x86/oprofile/op_model_athlon.c
--- a/arch/x86/oprofile/op_model_athlon.c~oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes
+++ a/arch/x86/oprofile/op_model_athlon.c
@@ -32,13 +32,13 @@
 #define CTRL_SET_ACTIVE(n) (n |= (1<<22))
 #define CTRL_SET_INACTIVE(n) (n &= ~(1<<22))
 #define CTRL_CLEAR_LO(x) (x &= (1<<21))
-#define CTRL_CLEAR_HI(x) ( x &= 0xfffffcf0 )
+#define CTRL_CLEAR_HI(x) (x &= 0xfffffcf0)
 #define CTRL_SET_ENABLE(val) (val |= 1<<20)
 #define CTRL_SET_USR(val,u) (val |= ((u & 1) << 16))
 #define CTRL_SET_KERN(val,k) (val |= ((k & 1) << 17))
 #define CTRL_SET_UM(val, m) (val |= (m << 8))
 #define CTRL_SET_EVENT_LOW(val, e) (val |= (e & 0xff))
-#define CTRL_SET_EVENT_HIGH(val,e) (val |= ((e >> 8) & 0xf))
+#define CTRL_SET_EVENT_HIGH(val, e) (val |= ((e >> 8) & 0xf))
 #define CTRL_SET_HOST_ONLY(val, h) (val |= ((h & 1) << 9))
 #define CTRL_SET_GUEST_ONLY(val, h) (val |= ((h & 1) << 8))
 
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
