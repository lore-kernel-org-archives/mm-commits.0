From: akpm@linux-foundation.org
Subject: - parport-remove-cvs-keywords.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:19:30 -0700
Message-ID: <200810182319.m9INJURH029498@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751822AbYJRXTj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:19:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     parport: remove CVS keywords
has been removed from the -mm tree.  Its filename was
     parport-remove-cvs-keywords.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parport: remove CVS keywords
From: Adrian Bunk <bunk@kernel.org>

Remove CVS keywords that weren't updated for a long time from comments.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/ieee1284.c |    2 +-
 drivers/parport/probe.c    |    2 +-
 drivers/parport/share.c    |    2 +-
 include/linux/parport.h    |    2 --
 4 files changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/parport/ieee1284.c~parport-remove-cvs-keywords drivers/parport/ieee1284.c
--- a/drivers/parport/ieee1284.c~parport-remove-cvs-keywords
+++ a/drivers/parport/ieee1284.c
@@ -1,4 +1,4 @@
-/* $Id: parport_ieee1284.c,v 1.4 1997/10/19 21:37:21 philip Exp $
+/*
  * IEEE-1284 implementation for parport.
  *
  * Authors: Phil Blundell <philb@gnu.org>
diff -puN drivers/parport/probe.c~parport-remove-cvs-keywords drivers/parport/probe.c
--- a/drivers/parport/probe.c~parport-remove-cvs-keywords
+++ a/drivers/parport/probe.c
@@ -1,4 +1,4 @@
-/* $Id: parport_probe.c,v 1.1 1999/07/03 08:56:17 davem Exp $
+/*
  * Parallel port device probing code
  *
  * Authors:    Carsten Gross, carsten@sol.wohnheim.uni-ulm.de
diff -puN drivers/parport/share.c~parport-remove-cvs-keywords drivers/parport/share.c
--- a/drivers/parport/share.c~parport-remove-cvs-keywords
+++ a/drivers/parport/share.c
@@ -1,4 +1,4 @@
-/* $Id: parport_share.c,v 1.15 1998/01/11 12:06:17 philip Exp $
+/*
  * Parallel-port resource manager code.
  * 
  * Authors: David Campbell <campbell@tirian.che.curtin.edu.au>
diff -puN include/linux/parport.h~parport-remove-cvs-keywords include/linux/parport.h
--- a/include/linux/parport.h~parport-remove-cvs-keywords
+++ a/include/linux/parport.h
@@ -1,5 +1,3 @@
-/* $Id: parport.h,v 1.1 1998/05/17 10:57:52 andrea Exp andrea $ */
