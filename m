From: akpm@linux-foundation.org
Subject: + kmodc-fix-kernel-doc-warning.patch added to -mm tree
Date: Wed, 18 Apr 2012 15:15:34 -0700
Message-ID: <20120418221534.47ADEA018B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:58255 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab2DRWPf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Apr 2012 18:15:35 -0400
Received: by qabg24 with SMTP id g24so126606qab.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Apr 2012 15:15:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net


The patch titled
     Subject: kmod.c: fix kernel-doc warning
has been added to the -mm tree.  Its filename is
     kmodc-fix-kernel-doc-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: kmod.c: fix kernel-doc warning

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
kmodc-fix-kernel-doc-warning.patch
ramoops-use-pstore-interface.patch
ramoops-use-pstore-interface-fix.patch
kconfig-update-compression-algorithm-info.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

