From: akpm@linux-foundation.org
Subject: [merged] kmodc-fix-kernel-doc-warning.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:33:42 -0700
Message-ID: <20120601193342.550A9A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:52311 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615Ab2FATdn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:33:43 -0400
Received: by mail-vb0-f74.google.com with SMTP id l22so244305vbn.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:33:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Subject: kmod.c: fix kernel-doc warning
has been removed from the -mm tree.  Its filename was
     kmodc-fix-kernel-doc-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Randy Dunlap <rdunlap@xenotime.net>
Subject: kmod.c: fix kernel-doc warning

Warning(kernel/kmod.c:419): No description found for parameter 'depth'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kmod.c~kmodc-fix-kernel-doc-warning kernel/kmod.c
--- a/kernel/kmod.c~kmodc-fix-kernel-doc-warning
+++ a/kernel/kmod.c
@@ -409,7 +409,7 @@ EXPORT_SYMBOL_GPL(usermodehelper_read_un
 
 /**
  * __usermodehelper_set_disable_depth - Modify usermodehelper_disabled.
- * depth: New value to assign to usermodehelper_disabled.
+ * @depth: New value to assign to usermodehelper_disabled.
  *
  * Change the value of usermodehelper_disabled (under umhelper_sem locked for
  * writing) and wakeup tasks waiting for it to change.
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
kconfig-update-compression-algorithm-info.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

