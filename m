From: akpm@linux-foundation.org
Subject: + doc-update-to-url-and-status-of-kernel-docstxt-entry.patch added to -mm tree
Date: Mon, 02 Jun 2008 23:07:23 -0700
Message-ID: <200806030607.m5367NZ9019097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752558AbYFCGH1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 02:07:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pj@sgi.com


The patch titled
     doc: update to URL and status of kernel-docs.txt entry
has been added to the -mm tree.  Its filename is
     doc-update-to-url-and-status-of-kernel-docstxt-entry.patch

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
Subject: doc: update to URL and status of kernel-docs.txt entry
From: Paul Jackson <pj@sgi.com>

Update status and URL for the "Gary's Encyclopedia" entry.

Signed-off-by: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-docs.txt |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN Documentation/kernel-docs.txt~doc-update-to-url-and-status-of-kernel-docstxt-entry Documentation/kernel-docs.txt
--- a/Documentation/kernel-docs.txt~doc-update-to-url-and-status-of-kernel-docstxt-entry
+++ a/Documentation/kernel-docs.txt
@@ -715,14 +715,14 @@
 
      * Name: "Gary's Encyclopedia - The Linux Kernel"
        Author: Gary (I suppose...).
-       URL: http://www.lisoleg.net/cgi-bin/lisoleg.pl?view=kernel.htm
-       Keywords: links, not found here?.
+       URL: http://slencyclopedia.berlios.de/index.html
+       Keywords: linux, community, everything!
        Description: Gary's Encyclopedia exists to allow the rapid finding
        of documentation and other information of interest to GNU/Linux
        users. It has about 4000 links to external pages in 150 major
        categories. This link is for kernel-specific links, documents,
-       sites... Look there if you could not find here what you were
-       looking for.
+       sites...  This list is now hosted by developer.Berlios.de,
+       but seems not to have been updated since sometime in 1999.
 
      * Name: "The home page of Linux-MM"
        Author: The Linux-MM team.
_

Patches currently in -mm which might be from pj@sgi.com are

cpusets-fix-and-update-documentation.patch
doc-update-to-url-and-status-of-kernel-docstxt-entry.patch
linux-next.patch
cpusets-fix-bug-when-adding-nonexistent-cpu-or-mem.patch
doc-document-the-kernel-doc-conventions-for-kernel-hackers.patch
doc-document-the-kernel-doc-conventions-for-kernel-hackers-grammar-fixes.patch

