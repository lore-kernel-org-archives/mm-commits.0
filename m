From: akpm@linux-foundation.org
Subject: + sysctl-remove-now-unused-typedef-ctl_table.patch added to -mm
 tree
Date: Tue, 10 Jun 2014 16:18:03 -0700
Message-ID: <5397922b.FX8Qme0kOj5IoghX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbaFJXSF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jun 2014 19:18:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + sysctl-remove-now-unused-typedef-ctl_table.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 10 Jun 2014 16:18:03 -0700


The patch titled
     Subject: sysctl: remove typedef ctl_table
has been added to the -mm tree.  Its filename is
     sysctl-remove-now-unused-typedef-ctl_table.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sysctl-remove-now-unused-typedef-ctl_table.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sysctl-remove-now-unused-typedef-ctl_table.patch

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
Subject: sysctl: remove typedef ctl_table

Remove the final user, and the typedef itself.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/sysctl.h~sysctl-remove-now-unused-typedef-ctl_table include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-remove-now-unused-typedef-ctl_table
+++ a/include/linux/sysctl.h
@@ -34,8 +34,6 @@ struct ctl_table_root;
 struct ctl_table_header;
 struct ctl_dir;
 
-typedef struct ctl_table ctl_table;
