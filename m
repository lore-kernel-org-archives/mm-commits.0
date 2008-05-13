From: akpm@linux-foundation.org
Subject: - atl1-bump-version-number.patch removed from -mm tree
Date: Tue, 13 May 2008 14:34:54 -0700
Message-ID: <200805132134.m4DLYshe000966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32858 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760226AbYEMVe4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:34:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jacliburn@bellsouth.net, mm-commits@vger.kernel.org


The patch titled
     atl1: bump version number
has been removed from the -mm tree.  Its filename was
     atl1-bump-version-number.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-net.patch

