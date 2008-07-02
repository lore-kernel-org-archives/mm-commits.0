From: akpm@linux-foundation.org
Subject: - uio-howtotmpl-use-unique-output-names.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:48:12 -0700
Message-ID: <200807020748.m627mCp5005713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761982AbYGBHsa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 03:48:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, greg@kroah.com, hjk@linutronix.de, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     uio-howto.tmpl: use unique output names
has been removed from the -mm tree.  Its filename was
     uio-howtotmpl-use-unique-output-names.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uio-howto.tmpl: use unique output names
From: Mike Frysinger <vapier@gentoo.org>

The Userspace I/O HOWTO template sets two different sections with the same
html output name (about.html).  This clearly won't work, so change the
first one to a unique "aboutthis.html" to prevent clobbering.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Hans J. Koch <hjk@linutronix.de>
Cc: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/uio-howto.tmpl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/DocBook/uio-howto.tmpl~uio-howtotmpl-use-unique-output-names Documentation/DocBook/uio-howto.tmpl
--- a/Documentation/DocBook/uio-howto.tmpl~uio-howtotmpl-use-unique-output-names
+++ a/Documentation/DocBook/uio-howto.tmpl
@@ -75,7 +75,7 @@ GPL version 2.
 </bookinfo>
 
 <chapter id="aboutthisdoc">
-<?dbhtml filename="about.html"?>
+<?dbhtml filename="aboutthis.html"?>
 <title>About this document</title>
 
 <sect1 id="translations">
_

Patches currently in -mm which might be from vapier@gentoo.org are

linux-next.patch
procfs-guide-drop-pointless-nbsp-entities.patch

