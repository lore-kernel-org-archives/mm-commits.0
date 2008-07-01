From: akpm@linux-foundation.org
Subject: + doc-doc-maintainers.patch added to -mm tree
Date: Tue, 01 Jul 2008 13:08:49 -0700
Message-ID: <200807012008.m61K8nRS012265@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753580AbYGAUJV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 16:09:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net, corbet@lwn.net, mtk.manpages@gmail.com


The patch titled
     doc: doc maintainers
has been added to the -mm tree.  Its filename is
     doc-doc-maintainers.patch

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
Subject: doc: doc maintainers
From: Randy Dunlap <rdunlap@xenotime.net>

Maintain the kernel's Documentation/ tree.

This includes tree layout and contents, although not much in terms of new
content production.  That will usually have to be done by someone familiar
with the software, at least in some rough form.

Includes review and editorial assistance for people contributing changes
to /Documentation.

Also includes prodding people for content if something is in need of
documentation.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN MAINTAINERS~doc-doc-maintainers MAINTAINERS
--- a/MAINTAINERS~doc-doc-maintainers
+++ a/MAINTAINERS
@@ -1423,6 +1423,14 @@ M:	kristen.c.accardi@intel.com
 L:	linux-acpi@vger.kernel.org
 S:	Supported
 
+DOCUMENTATION (/Documentation directory)
+P:     Michael Kerrisk
+M:     mtk.manpages@gmail.com
+P:     Randy Dunlap
+M:     rdunlap@xenotime.net
+L:     linux-doc@vger.kernel.org
+S:     Maintained
+
 DOUBLETALK DRIVER
 P:	James R. Van Zandt
 M:	jrv@vanzandt.mv.com
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

add-kernel-doc-for-simple_read_from_buffer-and-memory_read_from_buffer.patch
doc-doc-maintainers.patch

