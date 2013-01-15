From: akpm@linux-foundation.org
Subject: + checkpatch-add-joe-to-maintainers.patch added to -mm tree
Date: Tue, 15 Jan 2013 15:05:58 -0800
Message-ID: <20130115230558.7BF6831C1DA@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:50379 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934301Ab3AOXF7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Jan 2013 18:05:59 -0500
Received: by mail-yh0-f74.google.com with SMTP id w68so90713yhw.1
        for <mm-commits@vger.kernel.org>; Tue, 15 Jan 2013 15:05:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@shadowen.org


The patch titled
     Subject: checkpatch: add Joe to MAINTAINERS
has been added to the -mm tree.  Its filename is
     checkpatch-add-joe-to-maintainers.patch

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
Subject: checkpatch: add Joe to MAINTAINERS

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~checkpatch-add-joe-to-maintainers MAINTAINERS
--- a/MAINTAINERS~checkpatch-add-joe-to-maintainers
+++ a/MAINTAINERS
@@ -1935,7 +1935,8 @@ F:	drivers/misc/*
 
 CHECKPATCH
 M:	Andy Whitcroft <apw@canonical.com>
-S:	Supported
+M:	Joe Perches <joe@perches.com>
+S:	Maintained
 F:	scripts/checkpatch.pl
 
 CHINESE DOCUMENTATION
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
compiler-gcc4h-reorder-macros-based-upon-gcc-ver.patch
compiler-gcch-add-gcc-recommended-gcc_version-macro.patch
compiler-gcc34h-use-gcc_version-macro.patch
compiler-gcc4h-bugh-remove-duplicate-macros.patch
bugh-fix-build_bug_on-macro-in-__checker__.patch
bugh-prevent-double-evaulation-of-in-build_bug_on.patch
bugh-make-build_bug_on-generate-compile-time-error.patch
compilerh-bugh-prevent-double-error-messages-with-build_bug_on.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg.patch
get_maintainerpl-find-maintainers-for-removed-files.patch
checkpatch-prefer-dev_level-to-dev_printkkern_level.patch
checkpatch-warn-on-unnecessary-__devfoo-section-markings.patch
checkpatch-add-joe-to-maintainers.patch

