From: akpm@linux-foundation.org
Subject: [merged] remove-not-used-poison-pointer-macros.patch removed from -mm tree
Date: Fri, 11 Sep 2015 11:11:40 -0700
Message-ID: <55f3195c.pRfEw8QyNe+4zUic%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbbIKSLk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:11:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segoon@openwall.com, kirill.shutemov@linux.intel.com, solar@openwall.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/poison.h: remove not-used poison pointer macros
has been removed from the -mm tree.  Its filename was
     remove-not-used-poison-pointer-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vasily Kulikov <segoon@openwall.com>
Subject: include/linux/poison.h: remove not-used poison pointer macros

Signed-off-by: Vasily Kulikov <segoon@openwall.com>
Cc: Solar Designer <solar@openwall.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/poison.h |    7 -------
 1 file changed, 7 deletions(-)

diff -puN include/linux/poison.h~remove-not-used-poison-pointer-macros include/linux/poison.h
--- a/include/linux/poison.h~remove-not-used-poison-pointer-macros
+++ a/include/linux/poison.h
@@ -69,10 +69,6 @@
 #define ATM_POISON_FREE		0x12
 #define ATM_POISON		0xdeadbeef
 
-/********** net/ **********/
-#define NEIGHBOR_DEAD		0xdeadbeef
-#define NETFILTER_LINK_POISON	0xdead57ac
-
 /********** kernel/mutexes **********/
 #define MUTEX_DEBUG_INIT	0x11
 #define MUTEX_DEBUG_FREE	0x22
@@ -83,7 +79,4 @@
 /********** security/ **********/
 #define KEY_DESTROY		0xbd
 
-/********** sound/oss/ **********/
-#define OSS_POISON_FREE		0xAB
