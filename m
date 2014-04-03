From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-add-dlm_recover_callback_support-in-sysfs-fix-2.patch removed from
 -mm tree
Date: Thu, 03 Apr 2014 14:02:51 -0700
Message-ID: <533dcc7b.8sSmidb2mHAL/hQA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60744 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbaDCVCw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2014 17:02:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgoldwyn@suse.com, mfasheh@suse.com, jlbec@evilplan.org, sfr@canb.auug.org.au

Subject: [folded-merged] ocfs2-add-dlm_recover_callback_support-in-sysfs-fix-2.patch removed from -mm tree
To: sfr@canb.auug.org.au,jlbec@evilplan.org,mfasheh@suse.com,rgoldwyn@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Apr 2014 14:02:51 -0700


The patch titled
     Subject: ocfs2: VERIFY_OCTAL_PERMISSIONS fix up
has been removed from the -mm tree.  Its filename was
     ocfs2-add-dlm_recover_callback_support-in-sysfs-fix-2.patch

This patch was dropped because it was folded into ocfs2-add-dlm_recover_callback_support-in-sysfs.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: ocfs2: VERIFY_OCTAL_PERMISSIONS fix up

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stackglue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/stackglue.c~ocfs2-add-dlm_recover_callback_support-in-sysfs-fix-2 fs/ocfs2/stackglue.c
--- a/fs/ocfs2/stackglue.c~ocfs2-add-dlm_recover_callback_support-in-sysfs-fix-2
+++ a/fs/ocfs2/stackglue.c
@@ -611,7 +611,7 @@ static ssize_t ocfs2_dlm_recover_show(st
 }
 
 static struct kobj_attribute ocfs2_attr_dlm_recover_support =
-	__ATTR(dlm_recover_callback_support, S_IFREG | S_IRUGO,
+	__ATTR(dlm_recover_callback_support, S_IRUGO,
 	       ocfs2_dlm_recover_show, NULL);
 
 static struct attribute *ocfs2_attrs[] = {
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
ocfs2-add-dlm_recover_callback_support-in-sysfs.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch

