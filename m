From: akpm@linux-foundation.org
Subject: [merged]
 fs-affs-inodec-remove-double-extern-affs_symlink_inode_operations.patch
 removed from -mm tree
Date: Wed, 18 Feb 2015 11:43:42 -0800
Message-ID: <54e4eb6e.BUdykhLDs0QRohYS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46092 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbbBRTnn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:43:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/inode.c: remove double extern affs_symlink_inode_operations
has been removed from the -mm tree.  Its filename was
     fs-affs-inodec-remove-double-extern-affs_symlink_inode_operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs/inode.c: remove double extern affs_symlink_inode_operations

affs_symlink_inode_operations was already declared extern in affs.h

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/inode.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/affs/inode.c~fs-affs-inodec-remove-double-extern-affs_symlink_inode_operations fs/affs/inode.c
--- a/fs/affs/inode.c~fs-affs-inodec-remove-double-extern-affs_symlink_inode_operations
+++ a/fs/affs/inode.c
@@ -13,8 +13,6 @@
 #include <linux/gfp.h>
 #include "affs.h"
 
-extern const struct inode_operations affs_symlink_inode_operations;
