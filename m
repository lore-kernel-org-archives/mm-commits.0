From: akpm@linux-foundation.org
Subject: + atl1-bump-version-number.patch added to -mm tree
Date: Mon, 12 May 2008 15:23:36 -0700
Message-ID: <200805122223.m4CMNaOB012129@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754304AbYELWYI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 18:24:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jacliburn@bellsouth.net


The patch titled
     atl1: bump version number
has been added to the -mm tree.  Its filename is
     atl1-bump-version-number.patch

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
Subject: atl1: bump version number
From: Jay Cliburn <jacliburn@bellsouth.net>

atl1-2.1.3.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atlx/atl1.c |    2 +-
 drivers/net/atlx/atl1.h |    2 +-
 drivers/net/atlx/atlx.c |    2 +-
 drivers/net/atlx/atlx.h |    4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/net/atlx/atl1.c~atl1-bump-version-number drivers/net/atlx/atl1.c
--- a/drivers/net/atlx/atl1.c~atl1-bump-version-number
+++ a/drivers/net/atlx/atl1.c
@@ -1,7 +1,7 @@
 /*
  * Copyright(c) 2005 - 2006 Attansic Corporation. All rights reserved.
  * Copyright(c) 2006 - 2007 Chris Snook <csnook@redhat.com>
- * Copyright(c) 2006 Jay Cliburn <jcliburn@gmail.com>
+ * Copyright(c) 2006 - 2008 Jay Cliburn <jcliburn@gmail.com>
  *
  * Derived from Intel e1000 driver
  * Copyright(c) 1999 - 2005 Intel Corporation. All rights reserved.
diff -puN drivers/net/atlx/atl1.h~atl1-bump-version-number drivers/net/atlx/atl1.h
--- a/drivers/net/atlx/atl1.h~atl1-bump-version-number
+++ a/drivers/net/atlx/atl1.h
@@ -1,7 +1,7 @@
 /*
  * Copyright(c) 2005 - 2006 Attansic Corporation. All rights reserved.
  * Copyright(c) 2006 - 2007 Chris Snook <csnook@redhat.com>
- * Copyright(c) 2006 Jay Cliburn <jcliburn@gmail.com>
+ * Copyright(c) 2006 - 2008 Jay Cliburn <jcliburn@gmail.com>
  *
  * Derived from Intel e1000 driver
  * Copyright(c) 1999 - 2005 Intel Corporation. All rights reserved.
diff -puN drivers/net/atlx/atlx.c~atl1-bump-version-number drivers/net/atlx/atlx.c
--- a/drivers/net/atlx/atlx.c~atl1-bump-version-number
+++ a/drivers/net/atlx/atlx.c
@@ -2,7 +2,7 @@
  *
  * Copyright(c) 2005 - 2006 Attansic Corporation. All rights reserved.
  * Copyright(c) 2006 - 2007 Chris Snook <csnook@redhat.com>
- * Copyright(c) 2006 Jay Cliburn <jcliburn@gmail.com>
+ * Copyright(c) 2006 - 2008 Jay Cliburn <jcliburn@gmail.com>
  * Copyright(c) 2007 Atheros Corporation. All rights reserved.
  *
  * Derived from Intel e1000 driver
diff -puN drivers/net/atlx/atlx.h~atl1-bump-version-number drivers/net/atlx/atlx.h
--- a/drivers/net/atlx/atlx.h~atl1-bump-version-number
+++ a/drivers/net/atlx/atlx.h
@@ -2,7 +2,7 @@
  *
  * Copyright(c) 2005 - 2006 Attansic Corporation. All rights reserved.
  * Copyright(c) 2006 - 2007 Chris Snook <csnook@redhat.com>
- * Copyright(c) 2006 Jay Cliburn <jcliburn@gmail.com>
+ * Copyright(c) 2006 - 2008 Jay Cliburn <jcliburn@gmail.com>
  * Copyright(c) 2007 Atheros Corporation. All rights reserved.
  *
  * Derived from Intel e1000 driver
@@ -29,7 +29,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 
-#define ATLX_DRIVER_VERSION "2.1.1"
+#define ATLX_DRIVER_VERSION "2.1.3"
 MODULE_AUTHOR("Xiong Huang <xiong.huang@atheros.com>, \
 	Chris Snook <csnook@redhat.com>, Jay Cliburn <jcliburn@gmail.com>");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from jacliburn@bellsouth.net are

atl1-add-phy-power-save-mode.patch
atl1-fix-broken-suspend-and-resume.patch
atl1-add-shutdown-callback.patch
atl1-bump-version-number.patch

