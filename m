From: akpm@linux-foundation.org
Subject: + ocfs2-add-dlm_recover_callback_support-in-sysfs-fix-2.patch
 added to -mm tree
Date: Wed, 26 Mar 2014 13:19:36 -0700
Message-ID: <53333658.AkHl0WoMqv/KXAsY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57416 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaCZUTh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Mar 2014 16:19:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgoldwyn@suse.com, mfasheh@suse.com, jlbec@evilplan.org, sfr@canb.auug.org.au

Subject: + ocfs2-add-dlm_recover_callback_support-in-sysfs-fix-2.patch added to -mm tree
To: sfr@canb.auug.org.au,jlbec@evilplan.org,mfasheh@suse.com,rgoldwyn@suse.com
From: akpm@linux-foundation.org
Date: Wed, 26 Mar 2014 13:19:36 -0700


The patch titled
     Subject: ocfs2: VERIFY_OCTAL_PERMISSIONS fix up
has been added to the -mm tree.  Its filename is
     ocfs2-add-dlm_recover_callback_support-in-sysfs-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-add-dlm_recover_callback_support-in-sysfs-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-add-dlm_recover_callback_support-in-sysfs-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-add-dlm_recover_callback_support-in-sysfs-fix-2.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch
zram-propagate-error-to-user-fix-2.patch
cris-make-etrax_arch_v10-select-tty-for-use-in-debugport.patch
cris-cpuinfo_op-should-depend-on-config_proc_fs.patch
ia64-select-config_tty-for-use-of-tty_write_message-in-unaligned.patch
ppc-make-ppc_book3s_64-select-irq_work.patch
linux-next.patch
kernel-forkc-export-kernel_thread-to-modules.patch

