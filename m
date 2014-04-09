From: akpm@linux-foundation.org
Subject: [merged] ncpfs-remove-now-unused-printk-macro.patch removed from
 -mm tree
Date: Wed, 09 Apr 2014 10:55:43 -0700
Message-ID: <5345899f.61E4G5HmDs/BMLpM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933291AbaDIRzn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2014 13:55:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, petr@vandrovec.name, joe@perches.com

Subject: [merged] ncpfs-remove-now-unused-printk-macro.patch removed from -mm tree
To: joe@perches.com,petr@vandrovec.name,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 09 Apr 2014 10:55:43 -0700


The patch titled
     Subject: ncpfs: remove now unused PRINTK macro
has been removed from the -mm tree.  Its filename was
     ncpfs-remove-now-unused-printk-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
