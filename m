From: akpm@linux-foundation.org
Subject: [patch 14/84] nilfs2: fix white space issue in nilfs_mount()
Date: Mon, 23 May 2016 16:23:00 -0700
Message-ID: <574390d4.ceQVnBfLE6O2SLHw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42132 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbcEWXXB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:23:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, konishi.ryusuke@lab.ntt.co.jp

From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: fix white space issue in nilfs_mount()

Fix the following checkpatch.pl error and warnings:

ERROR: code indent should use tabs where possible
#1317: FILE: super.c:1317:
+ ^I^Is_new = true;$

WARNING: please, no space before tabs
#1317: FILE: super.c:1317:
+ ^I^Is_new = true;$

WARNING: please, no spaces at the start of a line
#1317: FILE: super.c:1317:
+ ^I^Is_new = true;$

Link: http://lkml.kernel.org/r/1461935747-10380-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nilfs2/super.c~nilfs2-fix-white-space-issue-in-nilfs_mount fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-fix-white-space-issue-in-nilfs_mount
+++ a/fs/nilfs2/super.c
@@ -1316,7 +1316,7 @@ nilfs_mount(struct file_system_type *fs_
 	}
 
 	if (!s->s_root) {
- 		s_new = true;
+		s_new = true;
 
 		/* New superblock instance created */
 		s->s_mode = mode;
_
