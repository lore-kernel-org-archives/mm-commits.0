From: akpm@linux-foundation.org
Subject: [merged] nilfs2-fix-code-indent-coding-style-issue.patch removed
 from -mm tree
Date: Fri, 27 May 2016 11:43:06 -0700
Message-ID: <5748953a.IFQyfsh/VqE6nxQ1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42463 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223AbcE0SnH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:43:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix code indent coding style issue
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-code-indent-coding-style-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: fix code indent coding style issue

This fixes checkpatch.pl warning "WARNING: suspect code indent for
conditional statements".

Link: http://lkml.kernel.org/r/1462886671-3521-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nilfs2/super.c~nilfs2-fix-code-indent-coding-style-issue fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-fix-code-indent-coding-style-issue
+++ a/fs/nilfs2/super.c
@@ -273,7 +273,7 @@ struct nilfs_super_block **nilfs_prepare
 		}
 	} else if (sbp[1] &&
 		   sbp[1]->s_magic != cpu_to_le16(NILFS_SUPER_MAGIC)) {
-			memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
+		memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
 	}
 
 	if (flip && sbp[1])
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are


