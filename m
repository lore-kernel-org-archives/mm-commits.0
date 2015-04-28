From: akpm@linux-foundation.org
Subject: + fs-affs-inodec-remove-unneeded-initialization.patch added to
 -mm tree
Date: Tue, 28 Apr 2015 13:50:58 -0700
Message-ID: <553ff2b2.dY/VBAXc7fIGQdGm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33218 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965792AbbD1Uu7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Apr 2015 16:50:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/inode.c: remove unneeded initialization
has been added to the -mm tree.  Its filename is
     fs-affs-inodec-remove-unneeded-initialization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-inodec-remove-unneeded-initialization.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-inodec-remove-unneeded-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs/inode.c: remove unneeded initialization

bh is initialized unconditionally in affs_add_entry()

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/affs/inode.c~fs-affs-inodec-remove-unneeded-initialization fs/affs/inode.c
--- a/fs/affs/inode.c~fs-affs-inodec-remove-unneeded-initialization
+++ a/fs/affs/inode.c
@@ -346,7 +346,7 @@ affs_add_entry(struct inode *dir, struct
 {
 	struct super_block *sb = dir->i_sb;
 	struct buffer_head *inode_bh = NULL;
-	struct buffer_head *bh = NULL;
+	struct buffer_head *bh;
 	u32 block = 0;
 	int retval;
 
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-affs-amigaffsc-remove-unneeded-initialization.patch
fs-affs-inodec-remove-unneeded-initialization.patch
fs-befs-btreec-remove-unneeded-initializations.patch

