From: akpm@linux-foundation.org
Subject: + fs-dcachec-fix-new-kernel-doc-warning.patch added to -mm tree
Date: Mon, 01 Aug 2011 13:40:02 -0700
Message-ID: <201108012040.p71Ke2gd013156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753349Ab1HAUke (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2011 16:40:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net, viro@zeniv.linux.org.uk


The patch titled
     fs/dcache.c: fix new kernel-doc warning
has been added to the -mm tree.  Its filename is
     fs-dcachec-fix-new-kernel-doc-warning.patch

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
Subject: fs/dcache.c: fix new kernel-doc warning
From: Randy Dunlap <rdunlap@xenotime.net>

Fix new kernel-doc warning in fs/dcache.c:

Warning(fs/dcache.c:797): No description found for parameter 'sb'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/dcache.c~fs-dcachec-fix-new-kernel-doc-warning fs/dcache.c
--- a/fs/dcache.c~fs-dcachec-fix-new-kernel-doc-warning
+++ a/fs/dcache.c
@@ -784,6 +784,7 @@ relock:
 
 /**
  * prune_dcache_sb - shrink the dcache
+ * @sb: superblock
  * @nr_to_scan: number of entries to try to free
  *
  * Attempt to shrink the superblock dcache LRU by @nr_to_scan entries. This is
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
fs-dcachec-fix-new-kernel-doc-warning.patch
linux-next.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
init-add-root=partuuid=uuid-partnroff=%d-support.patch
documentation-add-pointer-to-name_to_dev_t-for-root=-values.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

