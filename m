From: akpm@linux-foundation.org
Subject: + maintainers-chinese-maintainers-mailing-list-is-subscribers-only.patch added to -mm tree
Date: Tue, 20 Nov 2012 15:18:31 -0800
Message-ID: <20121120231832.07D68200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:54349 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab2KTXSe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Nov 2012 18:18:34 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so108552eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Nov 2012 15:18:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, harryxiyou@gmail.com


The patch titled
     Subject: MAINTAINERS: CHINESE MAINTAINERS mailing list is subscribers only
has been added to the -mm tree.  Its filename is
     maintainers-chinese-maintainers-mailing-list-is-subscribers-only.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: CHINESE MAINTAINERS mailing list is subscribers only

Mark it so.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Harry Wei <harryxiyou@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-chinese-maintainers-mailing-list-is-subscribers-only MAINTAINERS
--- a/MAINTAINERS~maintainers-chinese-maintainers-mailing-list-is-subscribers-only
+++ a/MAINTAINERS
@@ -1892,7 +1892,7 @@ F:	scripts/checkpatch.pl
 
 CHINESE DOCUMENTATION
 M:	Harry Wei <harryxiyou@gmail.com>
-L:	xiyoulinuxkernelgroup@googlegroups.com
+L:	xiyoulinuxkernelgroup@googlegroups.com (subscribers-only)
 L:	linux-kernel@zh-kernel.org (moderated for non-subscribers)
 S:	Maintained
 F:	Documentation/zh_CN/
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
printk-boot_delay-should-only-affect-output.patch
maintainers-chinese-maintainers-mailing-list-is-subscribers-only.patch
checkpatch-warn-on-unnecessary-line-continuations.patch
checkpatch-warn-about-using-config_experimental.patch
checkpatch-remove-reference-to-feature-removal-scheduletxt.patch
checkpatch-consolidate-if-foo-barfoo-checks-and-add-debugfs_remove.patch
checkpatch-allow-control-over-line-length-warning-default-remains-80.patch
checkpatch-extend-line-continuation-test.patch
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch

