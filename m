From: akpm@linux-foundation.org
Subject: [merged]
 key-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:39:38 -0700
Message-ID: <53960d7a.vCic7HUjpLLdJdOm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54313 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaFITji (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:39:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] key-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:39:38 -0700


The patch titled
     Subject: key: convert use of typedef ctl_table to struct ctl_table
has been removed from the -mm tree.  Its filename was
     key-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: key: convert use of typedef ctl_table to struct ctl_table

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/key.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/key.h~key-convert-use-of-typedef-ctl_table-to-struct-ctl_table include/linux/key.h
--- a/include/linux/key.h~key-convert-use-of-typedef-ctl_table-to-struct-ctl_table
+++ a/include/linux/key.h
@@ -332,7 +332,7 @@ do {									\
 } while (0)
 
 #ifdef CONFIG_SYSCTL
-extern ctl_table key_sysctls[];
+extern struct ctl_table key_sysctls[];
 #endif
 /*
  * the userspace interface
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

