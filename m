From: akpm@linux-foundation.org
Subject: - capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 19 Oct 2007 16:28:24 -0700
Message-ID: <200710192328.l9JNSPDn025784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53073 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935834AbXJSX3Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:29:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chrisw@sous-sol.org, morgan@kernel.org, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     capabilities-clean-up-file-capability-reading-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch

This patch was dropped because it was folded into capabilities-clean-up-file-capability-reading.patch

------------------------------------------------------
Subject: capabilities-clean-up-file-capability-reading-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: no space after that open parenthesis '('
#63: FILE: security/commoncap.c:160:
+		bprm->cap_permitted = to_cap_t( le32_to_cpu(caps->permitted) );

ERROR: no space before that close parenthesis ')'
#63: FILE: security/commoncap.c:160:
+		bprm->cap_permitted = to_cap_t( le32_to_cpu(caps->permitted) );

WARNING: line over 80 characters
#64: FILE: security/commoncap.c:161:
+		bprm->cap_inheritable = to_cap_t( le32_to_cpu(caps->inheritable) );

ERROR: no space after that open parenthesis '('
#64: FILE: security/commoncap.c:161:
+		bprm->cap_inheritable = to_cap_t( le32_to_cpu(caps->inheritable) );

ERROR: no space before that close parenthesis ')'
#64: FILE: security/commoncap.c:161:
+		bprm->cap_inheritable = to_cap_t( le32_to_cpu(caps->inheritable) );

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Cc: Andrew Morgan <morgan@kernel.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/commoncap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN security/commoncap.c~capabilities-clean-up-file-capability-reading-checkpatch-fixes security/commoncap.c
--- a/security/commoncap.c~capabilities-clean-up-file-capability-reading-checkpatch-fixes
+++ a/security/commoncap.c
@@ -207,8 +207,8 @@ static inline int cap_from_disk(struct v
 			bprm->cap_effective = true;
 		else
 			bprm->cap_effective = false;
-		bprm->cap_permitted = to_cap_t( le32_to_cpu(caps->permitted) );
-		bprm->cap_inheritable = to_cap_t( le32_to_cpu(caps->inheritable) );
+		bprm->cap_permitted = to_cap_t(le32_to_cpu(caps->permitted));
+		bprm->cap_inheritable = to_cap_t(le32_to_cpu(caps->inheritable));
 		return 0;
 	default:
 		return -EINVAL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic.patch
capabilities-clean-up-file-capability-reading.patch
capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
pm-qos-infrastructure-and-interface-fix.patch
pm-qos-infrastructure-and-interface-vs-git-acpi.patch
pm-qos-infrastructure-and-interface-vs-git-acpi-2.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
ext2-avoid-rec_len-overflow-with-64kb-block-size-checkpatch-fixes.patch
sync_sb_inodes-propagate-errors.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
kexec-add-bss-to-resource-tree-checkpatch-fixes.patch
kexec-introduce-bootmem_exclusive-checkpatch-fixes.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
git-block-vs-reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
