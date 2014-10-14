From: akpm@linux-foundation.org
Subject: [merged] fat-remove-redundant-sys_tz-declaration.patch removed
 from -mm tree
Date: Tue, 14 Oct 2014 11:21:12 -0700
Message-ID: <543d6998.+JgIbFg3IR2Nl3AP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44384 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbaJNSVL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:21:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: remove redundant sys_tz declaration
has been removed from the -mm tree.  Its filename was
     fat-remove-redundant-sys_tz-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fat: remove redundant sys_tz declaration

sys_tz is already declared extern struct in include/linux/time.h

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/misc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/fat/misc.c~fat-remove-redundant-sys_tz-declaration fs/fat/misc.c
--- a/fs/fat/misc.c~fat-remove-redundant-sys_tz-declaration
+++ a/fs/fat/misc.c
@@ -164,8 +164,6 @@ int fat_chain_add(struct inode *inode, i
 	return 0;
 }
 
-extern struct timezone sys_tz;
