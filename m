From: akpm@linux-foundation.org
Subject: [merged] nilfs2-remove-space-before-semicolon.patch removed from
 -mm tree
Date: Fri, 27 May 2016 11:43:04 -0700
Message-ID: <57489538.zbwB8r9ZKiNb+wkb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbcE0SnF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:43:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: remove space before semicolon
has been removed from the -mm tree.  Its filename was
     nilfs2-remove-space-before-semicolon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: remove space before semicolon

This fixes the checkpatch.pl warning "WARNING: space prohibited before
semicolon" at nilfs_store_magic_and_option().

Link: http://lkml.kernel.org/r/1462886671-3521-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nilfs2/super.c~nilfs2-remove-space-before-semicolon fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-remove-space-before-semicolon
+++ a/fs/nilfs2/super.c
@@ -886,7 +886,7 @@ int nilfs_store_magic_and_option(struct
 	nilfs->ns_interval = le32_to_cpu(sbp->s_c_interval);
 	nilfs->ns_watermark = le32_to_cpu(sbp->s_c_block_max);
 
-	return !parse_options(data, sb, 0) ? -EINVAL : 0 ;
+	return !parse_options(data, sb, 0) ? -EINVAL : 0;
 }
 
 int nilfs_check_feature_compatibility(struct super_block *sb,
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are


