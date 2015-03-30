From: akpm@linux-foundation.org
Subject: +
 doc-add-guest_nice-column-to-example-output-of-cat-proc-stat.patch added to -mm tree
Date: Mon, 30 Mar 2015 15:21:52 -0700
Message-ID: <5519cc80.qeEnCJu3hu1FeIoS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57116 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbbC3WVx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Mar 2015 18:21:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tklauser@distanz.ch, corbet@lwn.net, ozaki.ryota@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/filesystems/proc.txt: add guest_nice column to example output of `cat /proc/stat'
has been added to the -mm tree.  Its filename is
     doc-add-guest_nice-column-to-example-output-of-cat-proc-stat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/doc-add-guest_nice-column-to-example-output-of-cat-proc-stat.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/doc-add-guest_nice-column-to-example-output-of-cat-proc-stat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tobias Klauser <tklauser@distanz.ch>
Subject: Documentation/filesystems/proc.txt: add guest_nice column to example output of `cat /proc/stat'

Commit ce0e7b28fb75cb00 ("sched, cpuacct: Fix niced guest time
accounting") added the guest_nice column to /proc/stat, but the example
output of `cat /proc/stat' in Documentation/filesystems/proc.txt wasn't
updated accordingly.  Do so now.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Cc: Ryota Ozaki <ozaki.ryota@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/filesystems/proc.txt~doc-add-guest_nice-column-to-example-output-of-cat-proc-stat Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~doc-add-guest_nice-column-to-example-output-of-cat-proc-stat
+++ a/Documentation/filesystems/proc.txt
@@ -1260,9 +1260,9 @@ Various pieces   of  information about
 since the system first booted.  For a quick look, simply cat the file:
 
   > cat /proc/stat
-  cpu  2255 34 2290 22625563 6290 127 456 0 0
-  cpu0 1132 34 1441 11311718 3675 127 438 0 0
-  cpu1 1123 0 849 11313845 2614 0 18 0 0
+  cpu  2255 34 2290 22625563 6290 127 456 0 0 0
+  cpu0 1132 34 1441 11311718 3675 127 438 0 0 0
+  cpu1 1123 0 849 11313845 2614 0 18 0 0 0
   intr 114930548 113199788 3 0 5 263 0 4 [... lots more numbers ...]
   ctxt 1990473
   btime 1062191376
_

Patches currently in -mm which might be from tklauser@distanz.ch are

doc-add-guest_nice-column-to-example-output-of-cat-proc-stat.patch

