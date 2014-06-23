From: akpm@linux-foundation.org
Subject: [-] remove-strict_strto-definitions.patch removed from -mm tree
Date: Mon, 23 Jun 2014 16:16:42 -0700
Message-ID: <53a8b55a.cXYbVRrz+pe/RXLg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53921 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaFWXQn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 19:16:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalter@google.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/kernel.h: remove strict_strto* definitions
has been removed from the -mm tree.  Its filename was
     remove-strict_strto-definitions.patch

This patch was dropped because whoops

------------------------------------------------------
From: Daniel Walter <dwalter@google.com>
Subject: include/linux/kernel.h: remove strict_strto* definitions

Remove obsolete and unused strict_strto* macros.

Signed-off-by: Daniel Walter <dwalter@google.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN include/linux/kernel.h~remove-strict_strto-definitions include/linux/kernel.h
--- a/include/linux/kernel.h~remove-strict_strto-definitions
+++ a/include/linux/kernel.h
@@ -376,10 +376,6 @@ extern unsigned long simple_strtoul(cons
 extern long simple_strtol(const char *,char **,unsigned int);
 extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
 extern long long simple_strtoll(const char *,char **,unsigned int);
-#define strict_strtoul	kstrtoul
-#define strict_strtol	kstrtol
-#define strict_strtoull	kstrtoull
-#define strict_strtoll	kstrtoll
 
 extern int num_to_str(char *buf, int size, unsigned long long num);
 
_

Patches currently in -mm which might be from dwalter@google.com are


