From: akpm@linux-foundation.org
Subject: + drivers-base-driverc-remove-unused-to_dev-macro.patch added to -mm tree
Date: Tue, 06 May 2008 14:43:04 -0700
Message-ID: <200805062143.m46Lh4lq028867@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081AbYEFVnz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 17:43:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, greg@kroah.com


The patch titled
     drivers/base/driver.c: remove unused to_dev() macro
has been added to the -mm tree.  Its filename is
     drivers-base-driverc-remove-unused-to_dev-macro.patch

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
Subject: drivers/base/driver.c: remove unused to_dev() macro
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/driver.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/base/driver.c~drivers-base-driverc-remove-unused-to_dev-macro drivers/base/driver.c
--- a/drivers/base/driver.c~drivers-base-driverc-remove-unused-to_dev-macro
+++ a/drivers/base/driver.c
@@ -16,9 +16,6 @@
 #include <linux/string.h>
 #include "base.h"
 
-#define to_dev(node) container_of(node, struct device, driver_list)
-
