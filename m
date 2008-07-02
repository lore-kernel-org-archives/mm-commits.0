From: akpm@linux-foundation.org
Subject: + sysfs-rulestxt-reword-api-stability-statement.patch added to -mm tree
Date: Wed, 02 Jul 2008 10:21:30 -0700
Message-ID: <200807021721.m62HLU8F027407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752095AbYGBRV4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 13:21:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ntl@pobox.com, greg@kroah.com, sfr@canb.auug.org.au


The patch titled
     sysfs-rules.txt: reword API stability statement
has been added to the -mm tree.  Its filename is
     sysfs-rulestxt-reword-api-stability-statement.patch

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

sysfs-rulestxt-reword-api-stability-statement.patch

