From: akpm@linux-foundation.org
Subject: + ncpfs-remove-now-unused-printk-macro.patch added to -mm tree
Date: Mon, 10 Feb 2014 16:16:14 -0800
Message-ID: <52f96bce.IT2P041Jc6eaODOM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59980 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbaBKAQP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Feb 2014 19:16:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, petr@vandrovec.name, joe@perches.com

Subject: + ncpfs-remove-now-unused-printk-macro.patch added to -mm tree
To: joe@perches.com,petr@vandrovec.name
From: akpm@linux-foundation.org
Date: Mon, 10 Feb 2014 16:16:14 -0800


The patch titled
     Subject: ncpfs: remove now unused PRINTK macro
has been added to the -mm tree.  Its filename is
     ncpfs-remove-now-unused-printk-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ncpfs-remove-now-unused-printk-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ncpfs-remove-now-unused-printk-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: ncpfs: remove now unused PRINTK macro

Uses are gone, remove the macro.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Petr Vandrovec <petr@vandrovec.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/ncp_fs.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/ncpfs/ncp_fs.h~ncpfs-remove-now-unused-printk-macro fs/ncpfs/ncp_fs.h
--- a/fs/ncpfs/ncp_fs.h~ncpfs-remove-now-unused-printk-macro
+++ a/fs/ncpfs/ncp_fs.h
@@ -2,9 +2,6 @@
 #include "ncp_fs_i.h"
 #include "ncp_fs_sb.h"
 
-/* define because it is easy to change PRINTK to {*}PRINTK */
-#define PRINTK(format, args...) printk(KERN_DEBUG format , ## args)
