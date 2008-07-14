From: akpm@linux-foundation.org
Subject: + init-versionc-silenced-sparse-warning-by-declaring-the-version-string.patch added to -mm tree
Date: Mon, 14 Jul 2008 15:22:35 -0700
Message-ID: <200807142222.m6EMMZGN030589@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755665AbYGNWXZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 18:23:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: guilak@linux.vnet.ibm.com, daniel@danielguilak.com, randy.dunlap@oracle.com


The patch titled
     init/version.c: silence sparse warning by declaring the version string
has been added to the -mm tree.  Its filename is
     init-versionc-silenced-sparse-warning-by-declaring-the-version-string.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init/version.c: silence sparse warning by declaring the version string
From: Daniel Guilak <guilak@linux.vnet.ibm.com>

Signed-off-by: Daniel Guilak <daniel@danielguilak.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/version.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN init/version.c~init-versionc-silenced-sparse-warning-by-declaring-the-version-string init/version.c
--- a/init/version.c~init-versionc-silenced-sparse-warning-by-declaring-the-version-string
+++ a/init/version.c
@@ -16,6 +16,7 @@
 #define version(a) Version_ ## a
 #define version_string(a) version(a)
 
+extern int version_string(LINUX_VERSION_CODE);
 int version_string(LINUX_VERSION_CODE);
 
 struct uts_namespace init_uts_ns = {
_

Patches currently in -mm which might be from guilak@linux.vnet.ibm.com are

init-versionc-silenced-sparse-warning-by-declaring-the-version-string.patch
init-versionc-define-version_string-only-if-config_kallsyms-is-not-defined.patch

