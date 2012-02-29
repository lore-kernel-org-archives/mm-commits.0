From: akpm@linux-foundation.org
Subject: + maintainers-add-status-to-alpha-architecture.patch added to -mm tree
Date: Wed, 29 Feb 2012 12:25:57 -0800
Message-ID: <20120229202559.D038EA00AA@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:40895 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab2B2U0D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Feb 2012 15:26:03 -0500
Received: by qcsp5 with SMTP id p5so234346qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 29 Feb 2012 12:26:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     Subject: MAINTAINERS: add status to ALPHA architecture
has been added to the -mm tree.  Its filename is
     maintainers-add-status-to-alpha-architecture.patch

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
Subject: MAINTAINERS: add status to ALPHA architecture

Add missing S: status line to ALPHA.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-status-to-alpha-architecture MAINTAINERS
--- a/MAINTAINERS~maintainers-add-status-to-alpha-architecture
+++ a/MAINTAINERS
@@ -464,6 +464,7 @@ ALPHA PORT
 M:	Richard Henderson <rth@twiddle.net>
 M:	Ivan Kokshaysky <ink@jurassic.park.msu.ru>
 M:	Matt Turner <mattst88@gmail.com>
+S:	Odd Fixes
 L:	linux-alpha@vger.kernel.org
 F:	arch/alpha/
 
_
Subject: Subject: MAINTAINERS: add status to ALPHA architecture

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
thermal_sys-remove-unnecessary-line-continuations.patch
thermal_sys-remove-obfuscating-used-once-macros.patch
thermal_sys-kernel-style-cleanups.patch
thermal_sys-convert-printks-to-pr_level.patch
maintainers-fix-remoteproc-f-typo.patch
maintainers-update-mca-section.patch
maintainers-update-git-urls-for-26-deletions.patch
maintainers-add-status-to-alpha-architecture.patch
include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf.patch
checkpatch-add-some-strict-coding-style-checks.patch
checkpatchpl-be-silent-when-q-and-ignore-is-given.patch

