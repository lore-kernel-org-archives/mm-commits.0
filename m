From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-lguest-f-patterns.patch removed from -mm tree
Date: Mon, 06 Feb 2012 12:31:15 -0800
Message-ID: <20120206203115.60772A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:33821 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536Ab2BFUbQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2012 15:31:16 -0500
Received: by ggnp1 with SMTP id p1so612070ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 06 Feb 2012 12:31:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, dave@gnu.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update lguest F: patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-lguest-f-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update lguest F: patterns

commit 07fe9977b623 ("lguest: move the lguest tool to the tools
directory") moved the files, update the patterns.  Sort F: patterns
alphabetically too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Davidlohr Bueso <dave@gnu.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-update-lguest-f-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-lguest-f-patterns
+++ a/MAINTAINERS
@@ -3986,11 +3986,11 @@ M:	Rusty Russell <rusty@rustcorp.com.au>
 L:	lguest@lists.ozlabs.org
 W:	http://lguest.ozlabs.org/
 S:	Odd Fixes
-F:	Documentation/virtual/lguest/
+F:	arch/x86/include/asm/lguest*.h
 F:	arch/x86/lguest/
 F:	drivers/lguest/
 F:	include/linux/lguest*.h
-F:	arch/x86/include/asm/lguest*.h
+F:	tools/lguest/
 
 LINUX FOR IBM pSERIES (RS/6000)
 M:	Paul Mackerras <paulus@au.ibm.com>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
thermal_sys-remove-unnecessary-line-continuations.patch
thermal_sys-remove-obfuscating-used-once-macros.patch
thermal_sys-kernel-style-cleanups.patch
thermal_sys-convert-printks-to-pr_level.patch
maintainers-staging-cx25821-add-l-linux-media.patch
maintainers-fix-remoteproc-f-typo.patch
include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf.patch

