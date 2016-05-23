From: akpm@linux-foundation.org
Subject: [patch 27/84] nilfs2: fix code indent coding style issue
Date: Mon, 23 May 2016 16:23:36 -0700
Message-ID: <574390f8.KohhydKTbUvpFrLz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbcEWXXi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:23:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, konishi.ryusuke@lab.ntt.co.jp

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
