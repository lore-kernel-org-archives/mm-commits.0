From: akpm@linux-foundation.org
Subject: + fs-fix-inodec-kernel-doc-warnings.patch added to -mm tree
Date: Mon, 27 Oct 2008 13:15:02 -0700
Message-ID: <200810272015.m9RKF2Gl011291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752114AbYJ0UPn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 16:15:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, viro@zeniv.linux.org.uk


The patch titled
     fs: fix inode.c kernel-doc warnings
has been added to the -mm tree.  Its filename is
     fs-fix-inodec-kernel-doc-warnings.patch

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
Subject: fs: fix inode.c kernel-doc warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix fs/inode.c kernel-doc warnings:

Warning(linux-next-20081022//fs/inode.c:120): No description found for parameter 'sb'
Warning(linux-next-20081022//fs/inode.c:120): No description found for parameter 'inode'
Warning(linux-next-20081022//fs/inode.c:587): No description found for parameter 'sb'
Warning(linux-next-20081022//fs/inode.c:587): No description found for parameter 'inode'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/inode.c~fs-fix-inodec-kernel-doc-warnings fs/inode.c
--- a/fs/inode.c~fs-fix-inodec-kernel-doc-warnings
+++ a/fs/inode.c
@@ -110,8 +110,8 @@ static void wake_up_inode(struct inode *
 
 /**
  * inode_init_always - perform inode structure intialisation
- * @sb		- superblock inode belongs to.
- * @inode	- inode to initialise
+ * @sb: superblock inode belongs to.
+ * @inode: inode to initialise
  *
  * These are initializations that need to be done on every inode
  * allocation as the fields are not initialised by slab allocation.
@@ -574,8 +574,8 @@ __inode_add_to_lists(struct super_block 
 
 /**
  * inode_add_to_lists - add a new inode to relevant lists
- * @sb		- superblock inode belongs to.
- * @inode	- inode to mark in use
+ * @sb: superblock inode belongs to.
+ * @inode: inode to mark in use
  *
  * When an inode is allocated it needs to be accounted for, added to the in use
  * list, the owning superblock and the inode hash. This needs to be done under
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

docbook-fix-command-spacing.patch
docs-fix-managementstyle-book-name.patch
i2o-fix-kernel-doc-warnings.patch
linux-next.patch
fujitsu-laptop-fix-section-mismatch-warning.patch
acpi-compal-laptop-use-rfkill-switch-subsystem-fix.patch
kgdb-fix-kernel-doc-error.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
scsi-ioctl-fix-kernel-doc-warning.patch
fs-fix-inodec-kernel-doc-warnings.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
profile-likely-unlikely-macros.patch

