From: akpm@linux-foundation.org
Subject: [merged] checkpatch-fix-name-of-module_parm_desc.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:16:16 -0700
Message-ID: <20121005201616.A2EC7100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:64934 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab2JEUQR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:16:17 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so93875qae.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:16:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix name of "MODULE_PARM_DESC"
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-name-of-module_parm_desc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: checkpatch: fix name of "MODULE_PARM_DESC"

Fix macro name in checkpatch: s/PARAM/PARM/.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-name-of-module_parm_desc scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-name-of-module_parm_desc
+++ a/scripts/checkpatch.pl
@@ -2972,7 +2972,7 @@ sub process {
 			my $exceptions = qr{
 				$Declare|
 				module_param_named|
-				MODULE_PARAM_DESC|
+				MODULE_PARM_DESC|
 				DECLARE_PER_CPU|
 				DEFINE_PER_CPU|
 				__typeof__\(|
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
linux-next.patch
mm-use-%pk-for-proc-vmallocinfo.patch

