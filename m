From: akpm@linux-foundation.org
Subject: [merged] fs-fhandlec-add-linux-personalityh-for-ia64.patch removed from -mm tree
Date: Mon, 18 Apr 2011 11:03:10 -0700
Message-ID: <201104181759.p3IHxLu0016144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756225Ab1DRSD4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 14:03:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@suse.com, aneesh.kumar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     fs/fhandle.c: add <linux/personality.h> for ia64
has been removed from the -mm tree.  Its filename was
     fs-fhandlec-add-linux-personalityh-for-ia64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/fhandle.c: add <linux/personality.h> for ia64
From: Jeff Mahoney <jeffm@suse.com>

force_o_largefile() on ia64 is defined in <asm/fcntl.h> and requires
<linux/personality.h>.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fhandle.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/fhandle.c~fs-fhandlec-add-linux-personalityh-for-ia64 fs/fhandle.c
--- a/fs/fhandle.c~fs-fhandlec-add-linux-personalityh-for-ia64
+++ a/fs/fhandle.c
@@ -7,6 +7,7 @@
 #include <linux/exportfs.h>
 #include <linux/fs_struct.h>
 #include <linux/fsnotify.h>
+#include <linux/personality.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
_

Patches currently in -mm which might be from jeffm@suse.com are

origin.patch

