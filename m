From: akpm@linux-foundation.org
Subject: + nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch added to -mm tree
Date: Mon, 12 Jan 2009 15:27:42 -0800
Message-ID: <200901122327.n0CNRg0F014332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54566 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752136AbZALX2V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 18:28:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, konishi.ryusuke@lab.ntt.co.jp, penberg@cs.helsinki.fi


The patch titled
     nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#49: FILE: fs/nilfs2/bmap.c:737:
+^I^I^I   ^I  NILFS_BMAP_SMALL_LOW,$

total: 1 errors, 0 warnings, 45 lines checked

./patches/nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/bmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nilfs2/bmap.c~nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes fs/nilfs2/bmap.c
--- a/fs/nilfs2/bmap.c~nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes
+++ a/fs/nilfs2/bmap.c
@@ -734,7 +734,7 @@ int nilfs_bmap_read(struct nilfs_bmap *b
 				 NILFS_BMAP_LARGE_LOW,
 				 NILFS_BMAP_LARGE_HIGH) :
 		nilfs_direct_init(bmap,
-			   	  NILFS_BMAP_SMALL_LOW,
+				  NILFS_BMAP_SMALL_LOW,
 				  NILFS_BMAP_SMALL_HIGH);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
clocksource-pass-clocksource-to-read-callback.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
smp_call_function_single-be-slightly-less-stupid.patch
kernel-trace-ring_bufferc-reduce-inlining.patch
kernel-trace-ring_bufferc-use-div_round_up.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

