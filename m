From: akpm@linux-foundation.org
Subject: + fs-super-fix-kernel-doc-warning.patch added to -mm tree
Date: Thu, 27 May 2010 13:05:03 -0700
Message-ID: <201005272005.o4RK53RL011374@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36205 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751777Ab0E0UFJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 May 2010 16:05:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, viro@zeniv.linux.org.uk


The patch titled
     fs/super: fix kernel-doc warning
has been added to the -mm tree.  Its filename is
     fs-super-fix-kernel-doc-warning.patch

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
Subject: fs/super: fix kernel-doc warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix fs/super.c kernel-doc warning and function notation:
Warning(fs/super.c:957): No description found for parameter 'sb'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/super.c~fs-super-fix-kernel-doc-warning fs/super.c
--- a/fs/super.c~fs-super-fix-kernel-doc-warning
+++ a/fs/super.c
@@ -946,8 +946,8 @@ out:
 EXPORT_SYMBOL_GPL(vfs_kern_mount);
 
 /**
- * freeze_super -- lock the filesystem and force it into a consistent state
- * @super: the super to lock
+ * freeze_super - lock the filesystem and force it into a consistent state
+ * @sb: the super to lock
  *
  * Syncs the super to make sure the filesystem is consistent and calls the fs's
  * freeze_fs.  Subsequent calls to this without first thawing the fs will return
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
documentation-submittingdrivers-resources.patch
memcg-update-documentation-v8.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
linux-next.patch
compal-laptop-uses-hwmon-interfaces-depends-on-hwmon.patch
dib3000mc-reduce-large-stack-usage-fix.patch
media-ak881x-needs-slabh.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
scsi-fix-pmcraid-build-errors.patch
scsi-fix-be2iscsi-build.patch
scsi-fix-bnx2i-build-errors.patch
virtio_9ph-include-linux-typesh.patch
fusion-fix-kernel-doc-warnings.patch
fs-super-fix-kernel-doc-warning.patch
timerc-fix-kernel-doc-warning.patch
mtd-nand_base-fix-kernel-doc-warnings-typos.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

