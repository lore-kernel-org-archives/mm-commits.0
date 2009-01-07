From: akpm@linux-foundation.org
Subject: - block_write_begin-remove-useless-goto.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:14:26 -0800
Message-ID: <200901072214.n07MEQFY014342@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757274AbZAGWO3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fbuihuu@gmail.com, mm-commits@vger.kernel.org


The patch titled
     block_write_begin(): remove useless goto
has been removed from the -mm tree.  Its filename was
     block_write_begin-remove-useless-goto.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block_write_begin(): remove useless goto
From: Franck Bui-Huu <fbuihuu@gmail.com>

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/buffer.c~block_write_begin-remove-useless-goto fs/buffer.c
--- a/fs/buffer.c~block_write_begin-remove-useless-goto
+++ a/fs/buffer.c
@@ -2022,7 +2022,6 @@ int block_write_begin(struct file *file,
 			if (pos + len > inode->i_size)
 				vmtruncate(inode, inode->i_size);
 		}
-		goto out;
 	}
 
 out:
_

Patches currently in -mm which might be from fbuihuu@gmail.com are

origin.patch

