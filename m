From: akpm@linux-foundation.org
Subject: + smbfs-remove-duplicated-include.patch added to -mm tree
Date: Mon, 12 Apr 2010 22:29:20 -0400
Message-ID: <201004130530.o3D5UxUY015191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751311Ab0DMFbD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Apr 2010 01:31:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: weiyi.huang@gmail.com


The patch titled
     smbfs: remove duplicated #include
has been added to the -mm tree.  Its filename is
     smbfs-remove-duplicated-include.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smbfs: remove duplicated #include
From: Huang Weiyi <weiyi.huang@gmail.com>

Remove duplicated #include('s) in fs/smbfs/symlink.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/smbfs/symlink.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/smbfs/symlink.c~smbfs-remove-duplicated-include fs/smbfs/symlink.c
--- a/fs/smbfs/symlink.c~smbfs-remove-duplicated-include
+++ a/fs/smbfs/symlink.c
@@ -15,7 +15,6 @@
 #include <linux/pagemap.h>
 #include <linux/net.h>
 #include <linux/namei.h>
-#include <linux/slab.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
_

Patches currently in -mm which might be from weiyi.huang@gmail.com are

linux-next.patch
smbfs-remove-duplicated-include.patch

