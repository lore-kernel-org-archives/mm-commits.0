From: akpm@linux-foundation.org
Subject: + scripts-spellingtxt-spelling-of-uninitialized.patch added to
 -mm tree
Date: Tue, 28 Jul 2015 13:59:22 -0700
Message-ID: <55b7ed2a.icK/oaQOO1hRfYrN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53814 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbbG1U7W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jul 2015 16:59:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, sudip@vectorindia.org, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: spelling of uninitialized
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-spelling-of-uninitialized.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-spelling-of-uninitialized.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-spelling-of-uninitialized.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: scripts/spelling.txt: spelling of uninitialized

I just did a spelling mistake of uninitialized and wrote that as
unintialized.  Fortunately I noticed it in my final review.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/spelling.txt~scripts-spellingtxt-spelling-of-uninitialized scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-spelling-of-uninitialized
+++ a/scripts/spelling.txt
@@ -990,6 +990,7 @@ unexpectd||unexpected
 unexpeted||unexpected
 unfortunatelly||unfortunately
 unifiy||unify
+unintialized||uninitialized
 unknonw||unknown
 unknow||unknown
 unkown||unknown
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are

scripts-spellingtxt-spelling-of-uninitialized.patch
linux-next.patch

