From: akpm@linux-foundation.org
Subject: [merged] gru-copyright-fixes.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:49:16 -0700
Message-ID: <200906182249.n5IMnG6o008321@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754438AbZFRWxp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:53:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: copyright fixes
has been removed from the -mm tree.  Its filename was
     gru-copyright-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: copyright fixes
From: Jack Steiner <steiner@sgi.com>

Fix the copyright statements in a couple of GRU files.  No functional
changes are being made.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grukdump.c |   18 ++++++++++++++----
 drivers/misc/sgi-gru/grumain.c  |   18 ++++++++++++++----
 2 files changed, 28 insertions(+), 8 deletions(-)

diff -puN drivers/misc/sgi-gru/grukdump.c~gru-copyright-fixes drivers/misc/sgi-gru/grukdump.c
--- a/drivers/misc/sgi-gru/grukdump.c~gru-copyright-fixes
+++ a/drivers/misc/sgi-gru/grukdump.c
@@ -3,11 +3,21 @@
  *
  *            Dump GRU State
  *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
+ *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
  *
- * Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
 #include <linux/kernel.h>
diff -puN drivers/misc/sgi-gru/grumain.c~gru-copyright-fixes drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~gru-copyright-fixes
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -3,11 +3,21 @@
  *
  *            DRIVER TABLE MANAGER + GRU CONTEXT LOAD/UNLOAD
  *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
+ *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
  *
- * Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
 #include <linux/kernel.h>
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

