From: akpm@linux-foundation.org
Subject: - remove-useless-tolower-in-isofs.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:54:52 -0700
Message-ID: <200707162054.l6GKsqKh001857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39648 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760973AbXGPVWa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:22:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     remove useless tolower in isofs
has been removed from the -mm tree.  Its filename was
     remove-useless-tolower-in-isofs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove useless tolower in isofs
From: "young dave" <hidave.darkstar@gmail.com>

Remove useless tolower in isofs

Signed-off-by: dave young <hidave.darkstar@gmail.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/isofs/inode.c~remove-useless-tolower-in-isofs fs/isofs/inode.c
--- a/fs/isofs/inode.c~remove-useless-tolower-in-isofs
+++ a/fs/isofs/inode.c
@@ -197,7 +197,7 @@ isofs_hashi_common(struct dentry *dentry
 	hash = init_name_hash();
 	while (len--) {
 		c = tolower(*name++);
-		hash = partial_name_hash(tolower(c), hash);
+		hash = partial_name_hash(c, hash);
 	}
 	qstr->hash = end_name_hash(hash);
 
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
x86-fix-iounmaps-use-of-vm_structs-size-field.patch
