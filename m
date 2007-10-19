From: akpm@linux-foundation.org
Subject: - comment-typo-in-scripts-kconfig-makefile.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:46:42 -0700
Message-ID: <200710190346.l9J3kgHN013355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47209 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934418AbXJSDzg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob@landley.net, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Comment typo in scripts/kconfig/Makefile
has been removed from the -mm tree.  Its filename was
     comment-typo-in-scripts-kconfig-makefile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Comment typo in scripts/kconfig/Makefile
From: Rob Landley <rob@landley.net>

Typo in comment in scripts/kconfig/Makefile.

Signed-off-by: Rob Landley <rob@landley.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/kconfig/Makefile~comment-typo-in-scripts-kconfig-makefile scripts/kconfig/Makefile
--- a/scripts/kconfig/Makefile~comment-typo-in-scripts-kconfig-makefile
+++ a/scripts/kconfig/Makefile
@@ -84,7 +84,7 @@ help:
 # lxdialog stuff
 check-lxdialog  := $(srctree)/$(src)/lxdialog/check-lxdialog.sh
 
-# Use reursively expanded variables so we do not call gcc unless
+# Use recursively expanded variables so we do not call gcc unless
 # we really need to do so. (Do not call gcc as part of make mrproper)
 HOST_EXTRACFLAGS = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ccflags)
 HOST_LOADLIBES   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags $(HOSTCC))
_

Patches currently in -mm which might be from rob@landley.net are

origin.patch
git-kbuild.patch
