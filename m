From: akpm@linux-foundation.org
Subject: + checkpatch-fix-name-of-module_parm_desc.patch added to -mm tree
Date: Mon, 01 Oct 2012 15:51:22 -0700
Message-ID: <20121001225123.B36985C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:46896 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab2JAWv0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 18:51:26 -0400
Received: by lahj13 with SMTP id j13so106189lah.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 15:51:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: keescook@chromium.org, joe@perches.com


The patch titled
     Subject: checkpatch: fix name of "MODULE_PARM_DESC"
has been added to the -mm tree.  Its filename is
     checkpatch-fix-name-of-module_parm_desc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
audith-replace-defines-with-c-stubs.patch
audith-replace-defines-with-c-stubs-fix.patch
poweroff-fix-bug-in-orderly_poweroff.patch
checkpatch-fix-name-of-module_parm_desc.patch
coredump-make-core-dump-functionality-optional.patch
coredump-make-core-dump-functionality-optional-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
coredump-update-coredump-related-headers.patch

