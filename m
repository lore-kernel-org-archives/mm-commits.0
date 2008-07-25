From: akpm@linux-foundation.org
Subject: - init-versionc-silenced-sparse-warning-by-declaring-the-version-string.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:55:10 -0700
Message-ID: <200807252255.m6PMtA2x002954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753128AbYGYW4k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:56:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guilak@linux.vnet.ibm.com, daniel@danielguilak.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     init/version.c: silence sparse warning by declaring the version string
has been removed from the -mm tree.  Its filename was
     init-versionc-silenced-sparse-warning-by-declaring-the-version-string.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

