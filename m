From: akpm@linux-foundation.org
Subject: - fs-inode-fix-kernel-doc-notation.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:16:19 -0800
Message-ID: <200901072216.n07MGJce016012@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56588 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759991AbZAGWQY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:16:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs/inode: fix kernel-doc notation
has been removed from the -mm tree.  Its filename was
     fs-inode-fix-kernel-doc-notation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/inode: fix kernel-doc notation
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc notation:

Warning(linux-2.6.28-git3//fs/inode.c:120): No description found for parameter 'sb'
Warning(linux-2.6.28-git3//fs/inode.c:120): No description found for parameter 'inode'
Warning(linux-2.6.28-git3//fs/inode.c:588): No description found for parameter 'sb'
Warning(linux-2.6.28-git3//fs/inode.c:588): No description found for parameter 'inode'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/inode.c~fs-inode-fix-kernel-doc-notation fs/inode.c
--- a/fs/inode.c~fs-inode-fix-kernel-doc-notation
+++ a/fs/inode.c
@@ -110,8 +110,8 @@ static void wake_up_inode(struct inode *
 
 /**
  * inode_init_always - perform inode structure intialisation
- * @sb		- superblock inode belongs to.
- * @inode	- inode to initialise
+ * @sb: superblock inode belongs to
+ * @inode: inode to initialise
  *
  * These are initializations that need to be done on every inode
  * allocation as the fields are not initialised by slab allocation.
@@ -576,8 +576,8 @@ __inode_add_to_lists(struct super_block 
 
 /**
  * inode_add_to_lists - add a new inode to relevant lists
- * @sb		- superblock inode belongs to.
- * @inode	- inode to mark in use
+ * @sb: superblock inode belongs to
+ * @inode: inode to mark in use
  *
  * When an inode is allocated it needs to be accounted for, added to the in use
  * list, the owning superblock and the inode hash. This needs to be done under
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
leds-add-a-dac124s085-spi-led-driver-fix.patch
mtd-fix-nettel-printk-formats.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sunrpc-fix-rdma-dependency.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
max3100-spi-uart-driver-select-serial_core.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
jbd-remove-excess-kernel-doc-notation.patch
w1-add-list-masters-w1-command.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch
fix-similar-typos-to-successfull-v2.patch
kmemleak-add-documentation-on-the-memory-leak-detector.patch

