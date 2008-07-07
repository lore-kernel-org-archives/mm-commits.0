From: akpm@linux-foundation.org
Subject: - sysfs-rulestxt-reword-api-stability-statement.patch removed from -mm tree
Date: Sun, 06 Jul 2008 20:05:44 -0700
Message-ID: <200807070305.m6735iVb004842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753440AbYGGDFx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 23:05:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ntl@pobox.com, greg@kroah.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     sysfs-rules.txt: reword API stability statement
has been removed from the -mm tree.  Its filename was
     sysfs-rulestxt-reword-api-stability-statement.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysfs-rules.txt: reword API stability statement
From: Nathan Lynch <ntl@pobox.com>

The first paragraph of this document implies that user space developers
shouldn't use sysfs at all, but then it goes on to describe rules that
developers should follow when accessing sysfs.  Not only is this somewhat
self-contradictory, it has been shown to discourage developers from using
established sysfs interfaces.

A note of caution is more appropriate than a blanket "sysfs will never
be stable" assertion.

Signed-off-by: Nathan Lynch <ntl@pobox.com>
Cc: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysfs-rules.txt |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN Documentation/sysfs-rules.txt~sysfs-rulestxt-reword-api-stability-statement Documentation/sysfs-rules.txt
--- a/Documentation/sysfs-rules.txt~sysfs-rulestxt-reword-api-stability-statement
+++ a/Documentation/sysfs-rules.txt
@@ -3,9 +3,8 @@ Rules on how to access information in th
 The kernel-exported sysfs exports internal kernel implementation details
 and depends on internal kernel structures and layout. It is agreed upon
 by the kernel developers that the Linux kernel does not provide a stable
-internal API. As sysfs is a direct export of kernel internal
-structures, the sysfs interface cannot provide a stable interface either;
-it may always change along with internal kernel changes.
+internal API. Therefore, there are aspects of the sysfs interface that
+may not be stable across kernel releases.
 
 To minimize the risk of breaking users of sysfs, which are in most cases
 low-level userspace applications, with a new kernel release, the users
_

Patches currently in -mm which might be from ntl@pobox.com are

linux-next.patch

