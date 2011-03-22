From: akpm@linux-foundation.org
Subject: [folded] fs-coda-fix-compile-warning-when-config_sysctl=n-fix.patch removed from -mm tree
Date: Tue, 22 Mar 2011 16:08:25 -0700
Message-ID: <201103222308.p2MN8QRZ000673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753430Ab1CVXIv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Mar 2011 19:08:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jaharkes@cs.cmu.edu, rakib.mullick@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fs-coda-fix-compile-warning-when-config_sysctl=n-fix
has been removed from the -mm tree.  Its filename was
     fs-coda-fix-compile-warning-when-config_sysctl=n-fix.patch

This patch was dropped because it was folded into fs-coda-fix-compile-warning-when-config_sysctl=n.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs-coda-fix-compile-warning-when-config_sysctl=n-fix
From: Andrew Morton <akpm@linux-foundation.org>

remove unneeded stub macros

Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Rakib Mullick <rakib.mullick@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/sysctl.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN fs/coda/sysctl.c~fs-coda-fix-compile-warning-when-config_sysctl=n-fix fs/coda/sysctl.c
--- a/fs/coda/sysctl.c~fs-coda-fix-compile-warning-when-config_sysctl=n-fix
+++ a/fs/coda/sysctl.c
@@ -61,9 +61,4 @@ void coda_sysctl_clean(void)
 		fs_table_header = NULL;
 	}
 }
-#else
-
-#define	coda_sysctl_init()		do { }  while (0);
-#define	coda_sysctl_clean()		do { }	while (0);
