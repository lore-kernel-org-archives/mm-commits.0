From: akpm@osdl.org
Subject: - fsstack-introduce-fsstack_copy_attrinode_-fs-stackc-should-include-linux-fs_stackh.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:47:41 -0800
Message-ID: <200612080847.kB88lfWJ013854@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37167 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032532AbWLHIu6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:50:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     fs/stack.c should #include <linux/fs_stack.h>
has been removed from the -mm tree.  Its filename was
     fsstack-introduce-fsstack_copy_attrinode_-fs-stackc-should-include-linux-fs_stackh.patch

This patch was dropped because it was folded into fsstack-introduce-fsstack_copy_attrinode_.patch

------------------------------------------------------
Subject: fs/stack.c should #include <linux/fs_stack.h>
From: Adrian Bunk <bunk@stusta.de>

Every file should #include the headers containing the prototypes for
its global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/stack.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN fs/stack.c~fsstack-introduce-fsstack_copy_attrinode_-fs-stackc-should-include-linux-fs_stackh fs/stack.c
--- a/fs/stack.c~fsstack-introduce-fsstack_copy_attrinode_-fs-stackc-should-include-linux-fs_stackh
+++ a/fs/stack.c
@@ -1,5 +1,6 @@
 #include <linux/module.h>
 #include <linux/fs.h>
+#include <linux/fs_stack.h>
 
 /* does _NOT_ require i_mutex to be held.
  *
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
generic-bug-implementation.patch
fsstack-introduce-fsstack_copy_attrinode_.patch
fsstack-introduce-fsstack_copy_attrinode_-fs-stackc-should-include-linux-fs_stackh.patch
i4l-remove-the-broken-hisax_amd7930-option.patch
make-drivers-md-dm-snapcksnapd-static.patch

