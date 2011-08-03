From: akpm@linux-foundation.org
Subject: [folded] fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory-fix.patch removed from -mm tree
Date: Wed, 03 Aug 2011 14:06:37 -0700
Message-ID: <201108032106.p73L6bXo013970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752956Ab1HCVGn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2011 17:06:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, akinobu.mita@gmail.com, rdunlap@xenotime.net, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory-fix
has been removed from the -mm tree.  Its filename was
     fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory-fix.patch

This patch was dropped because it was folded into fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory-fix
From: Andrew Morton <akpm@linux-foundation.org>

remove extraneous semicolon, per Randy

Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fault-inject.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/fault-inject.h~fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory-fix include/linux/fault-inject.h
--- a/include/linux/fault-inject.h~fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory-fix
+++ a/include/linux/fault-inject.h
@@ -47,7 +47,7 @@ struct dentry *fault_create_debugfs_attr
 #else /* CONFIG_FAULT_INJECTION_DEBUG_FS */
 
 static inline struct dentry *fault_create_debugfs_attr(const char *name,
-			struct dentry *parent, struct fault_attr *attr);
+			struct dentry *parent, struct fault_attr *attr)
 {
 	return ERR_PTR(-ENODEV);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory.patch
cris-fix-a-build-error-in-kernel-forkc.patch
drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch

