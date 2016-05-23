From: akpm@linux-foundation.org
Subject: [patch 26/84] nilfs2: remove space before semicolon
Date: Mon, 23 May 2016 16:23:34 -0700
Message-ID: <574390f6.l667ETF0bsVsVI8I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbcEWXXf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:23:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, konishi.ryusuke@lab.ntt.co.jp

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
